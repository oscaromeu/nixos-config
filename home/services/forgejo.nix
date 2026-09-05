{ pkgs, config, ... }:
let

  workDir = "${config.home.homeDirectory}/forgejo";
  pgSocket = "${config.home.homeDirectory}/pg"; # keep in sync with postgres.nix

  # The NAS has no tailscale yet — LAN address until it does.
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
        # A user unit cannot bind 22, so forgejo runs its own ssh server on a
        # high port; keys live in its database, not in authorized_keys.
        START_SSH_SERVER = true;
        SSH_DOMAIN = host;
        SSH_PORT = 2222;
        SSH_LISTEN_PORT = 2222;
      };

      # Over the postgres socket as the unix user: peer auth, no password.
      database = {
        DB_TYPE = "postgres";
        HOST = pgSocket;
        NAME = "forgejo";
        USER = user;
        SSL_MODE = "disable";
      };

      cache = {
        ADAPTER = "redis";
        HOST = "redis://127.0.0.1:6379/0";
      };
      session = {
        PROVIDER = "redis";
        PROVIDER_CONFIG = "redis://127.0.0.1:6379/1";
      };

      # The secrets are generated on the machine at first start (see below),
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

      # journald already keeps the logs.
      log.MODE = "console";

      # No CI on the NAS.
      actions.ENABLED = false;
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
      "select 1 from pg_database where datname = 'forgejo'" | grep -qx 1 ||
      ${pg}/bin/createdb -h ${pgSocket} forgejo
    # The admin commands assume the schema exists; on a fresh database
    # nothing has created it yet.
    ${forgejo} --config ${settings} migrate
    # First login asks to change it, so the file only matters once. The email
    # is a placeholder: the repo is public and there is no mailer anyway.
    ${forgejo} --config ${settings} admin user list | grep -qw ${user} ||
      ${forgejo} --config ${settings} admin user create \
        --admin --username ${user} --email ${user}@rebost.lan --random-password |
        sed -n 's/.*random password is: //p' > ${workDir}/admin_password
  '';

  forgejo = "${pkgs.forgejo}/bin/forgejo";
  user = config.home.username;

  pg = pkgs.postgresql_17;

in
{
  # The CLI is the admin interface (user create, doctor, dump).
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
      Environment = [ "FORGEJO_WORK_DIR=${workDir}" ];
      ExecStartPre = "${setup}";
      ExecStart = "${forgejo} web --config ${settings}";
      Restart = "on-failure";
      RestartSec = 5;
    };

    Install.WantedBy = [ "default.target" ];
  };
}
