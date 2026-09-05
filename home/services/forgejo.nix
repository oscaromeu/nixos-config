{
  pkgs,
  config,
  lib,
  profile,
  ...
}:
let

  workDir = "${config.xdg.stateHome}/forgejo";
  pgSocket = "${config.xdg.stateHome}/postgres"; # keep in sync with postgres.nix

  host = "10.69.1.32";

  settings = (pkgs.formats.iniWithGlobalSection { }).generate "app.ini" {
    globalSection = {
      APP_NAME = "rebost";
      RUN_MODE = "prod";
      WORK_PATH = workDir;
    };

    sections = {
      server = {
        DOMAIN = host;
        ROOT_URL = "http://${host}:3000/";
        HTTP_ADDR = "0.0.0.0";
        HTTP_PORT = 3000;
        APP_DATA_PATH = "${workDir}/data";
        START_SSH_SERVER = true;
        SSH_DOMAIN = host;
        SSH_PORT = 2222;
        SSH_LISTEN_PORT = 2222;
      };

      database = {
        DB_TYPE = "postgres";
        HOST = pgSocket;
        NAME = "forgejo";
        USER = "forgejo";
        SSL_MODE = "disable"; #  WORKOUT! pending to enable TLS on the socket, see postgres.nix
      };

      cache = {
        ADAPTER = "redis";
        HOST = "redis://127.0.0.1:6379/0";
      };
      session = {
        PROVIDER = "redis";
        PROVIDER_CONFIG = "redis://127.0.0.1:6379/1";
      };

      # The secrets are generated on the machine at first start,
      # so the app.ini in the store never holds one.
      security = {
        INSTALL_LOCK = true;
        SECRET_KEY_URI = "file:${workDir}/secret_key";
        INTERNAL_TOKEN_URI = "file:${workDir}/internal_token";
      };

      # Without the URI forgejo generates one and tries to save it back into
      # app.ini — read-only in the store, so it crash-loops.
      oauth2.JWT_SECRET_URI = "file:${workDir}/oauth2_jwt_secret";

      # Single-user instance: accounts come from `forgejo admin user create`.
      service.DISABLE_REGISTRATION = true;

      repository = {
        ENABLE_PUSH_CREATE_USER = true;
        DEFAULT_PRIVATE = "private";
      };

      log.MODE = "console";

      actions.ENABLED = true;
    };
  };

  setup = pkgs.writeShellScript "forgejo-setup" ''
    mkdir -p ${workDir}/data
    umask 077
    [ -s ${workDir}/secret_key ] ||
      ${forgejo} generate secret SECRET_KEY > ${workDir}/secret_key
    [ -s ${workDir}/internal_token ] ||
      ${forgejo} generate secret INTERNAL_TOKEN > ${workDir}/internal_token
    [ -s ${workDir}/oauth2_jwt_secret ] ||
      ${forgejo} generate secret JWT_SECRET > ${workDir}/oauth2_jwt_secret
    ${pg}/bin/psql -h ${pgSocket} -d postgres -tAc \
      "select 1 from pg_roles where rolname = 'forgejo'" | grep -qx 1 ||
      ${pg}/bin/createuser -h ${pgSocket} forgejo
    ${pg}/bin/psql -h ${pgSocket} -d postgres -tAc \
      "select 1 from pg_database where datname = 'forgejo'" | grep -qx 1 ||
      ${pg}/bin/createdb -h ${pgSocket} -O forgejo forgejo
    # The admin commands assume the schema exists; on a fresh database
    # nothing has created it yet.
    ${forgejo} --config ${settings} migrate
    # First login asks to change it, so the file only matters once. The email
    # is a placeholder: the repo is public and there is no mailer anyway.
    if ! ${forgejo} --config ${settings} admin user list | grep -qw ${user}; then
      ${forgejo} generate secret SECRET_KEY > ${workDir}/admin_password
      ${forgejo} --config ${settings} admin user create \
        --admin --username ${user} --email ${user}@rebost.lan \
        --password "$(cat ${workDir}/admin_password)"
    fi
  '';

  # The web API is the only writer of user ssh keys (the CLI has no key
  # command), so this runs after the server is up. The common case — key
  # already registered — is a single psql query, no tokens involved.
  ensureKeys = pkgs.writeShellScript "forgejo-ensure-keys" ''
    for i in $(seq 1 30); do
      ${pkgs.curl}/bin/curl -sf -o /dev/null http://localhost:3000/api/healthz && break
      sleep 1
    done
    ${lib.concatStrings (
      lib.imap1 (i: key: ''
        blob='${builtins.elemAt (lib.splitString " " key) 1}'
        if ! ${pg}/bin/psql -h ${pgSocket} -d forgejo -tAc \
            "select 1 from public_key where content like '%'||'$blob'||'%'" | grep -qx 1; then
          ${pg}/bin/psql -h ${pgSocket} -d forgejo -c \
            "delete from access_token where name = 'nix-ensure-keys'" >/dev/null
          token=$(${forgejo} --config ${settings} admin user generate-access-token \
            --username ${user} --token-name nix-ensure-keys --scopes write:user --raw | tail -1 | tr -d '[:space:]')
          ${pkgs.curl}/bin/curl -sf -X POST http://localhost:3000/api/v1/user/keys \
            -H "Authorization: token $token" -H "Content-Type: application/json" \
            -d '{"title":"nix-${toString i}","key":"${key}"}' >/dev/null ||
            echo "ensure-keys: failed to register key ${toString i}" >&2
          ${pg}/bin/psql -h ${pgSocket} -d forgejo -c \
            "delete from access_token where name = 'nix-ensure-keys'" >/dev/null
        fi
      '') profile.sshKeys
    )}
    exit 0
  '';

  forgejo = "${pkgs.forgejo}/bin/forgejo";
  user = config.home.username;

  pg = pkgs.postgresql_17;

in
{
  home.packages = [ pkgs.forgejo ];

  systemd.user.services.forgejo = {
    Unit = {
      Description = "Forgejo";
      # postgres is Type=notify, so After here means it accepts connections.
      Wants = [
        "postgres.service"
        "valkey.service"
        "network-online.target"
      ];
      After = [
        "postgres.service"
        "valkey.service"
        "network-online.target"
      ];
    };

    Service = {
      StateDirectory = "forgejo";
      StateDirectoryMode = "0700";
      Environment = [ "FORGEJO_WORK_DIR=${workDir}" ];
      ExecStartPre = "${setup}";
      ExecStart = "${forgejo} web --config ${settings}";
      Restart = "on-failure";
      RestartSec = 5;
    }
    // lib.optionalAttrs (profile.sshKeys != [ ]) { ExecStartPost = "${ensureKeys}"; };

    Install.WantedBy = [ "default.target" ];
  };
}
