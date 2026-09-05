{ pkgs, config, ... }:
let

  pg = pkgs.postgresql_17;

  baseDir = "${config.xdg.stateHome}/postgres";
  dataDir = "${baseDir}/data";

  init = pkgs.writeShellScript "pg-init" ''
    if [ ! -f ${dataDir}/PG_VERSION ]; then
      ${pg}/bin/initdb -D ${dataDir} \
        --locale=C.UTF-8 \
        --auth-local=peer --auth-host=scram-sha-256
    fi
  '';

  # Auth policy lives in git: both files go in as flags, so the copies initdb
  # leaves in the data dir are dead letter.
  hba = pkgs.writeText "pg_hba.conf" ''
    # forgejo runs as the ${config.home.username} unix user but connects as its own role.
    local forgejo forgejo peer map=forgejo
    local all all peer
    host all all 127.0.0.1/32 scram-sha-256
    host all all ::1/128 scram-sha-256
  '';

  ident = pkgs.writeText "pg_ident.conf" ''
    # MAPNAME SYSTEM-USERNAME PG-USERNAME
    forgejo ${config.home.username} forgejo
  '';

in
{
  # psql and friends on the PATH.
  home.packages = [ pg ];

  # Clients default to /run/postgresql otherwise, so a bare `psql` fails.
  home.sessionVariables.PGHOST = baseDir;

  systemd.user.services.postgres = {
    Unit = {
      Description = "PostgreSQL";
      # sops writes the cipher.env this unit reads: without the ordering,
      # the first boot after a fresh install races it and archiving fails.
      Wants = [ "sops-nix.service" ];
      After = [ "sops-nix.service" ];
    };

    Service = {
      StateDirectory = "postgres";
      StateDirectoryMode = "0700";
      Type = "notify";
      Environment = [ "PGBACKREST_CONFIG=${config.xdg.configHome}/pgbackrest/pgbackrest.conf" ];
      EnvironmentFile = "-${config.xdg.configHome}/pgbackrest/cipher.env";
      ExecStartPre = "${init}";
      ExecStart = "${pg}/bin/postgres -D ${dataDir} -c unix_socket_directories=${baseDir} -c listen_addresses= -c hba_file=${hba} -c ident_file=${ident} -c archive_mode=on -c \"archive_command=${pkgs.pgbackrest}/bin/pgbackrest --stanza=main archive-push %%p\"";
      Restart = "on-failure";
      RestartSec = 5;
    };

    Install.WantedBy = [ "default.target" ];
  };
}
