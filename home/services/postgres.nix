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

in
{
  # psql and friends on the PATH.
  home.packages = [ pg ];

  # Clients default to /run/postgresql otherwise, so a bare `psql` fails.
  home.sessionVariables.PGHOST = baseDir;

  systemd.user.services.postgres = {
    Unit.Description = "PostgreSQL";

    Service = {
      StateDirectory = "postgres";
      StateDirectoryMode = "0700";
      Type = "notify";
      Environment = [ "PGBACKREST_CONFIG=${config.xdg.configHome}/pgbackrest/pgbackrest.conf" ];
      EnvironmentFile = "-${config.xdg.configHome}/pgbackrest/cipher.env";
      ExecStartPre = "${init}";
      ExecStart = "${pg}/bin/postgres -D ${dataDir} -c unix_socket_directories=${baseDir} -c listen_addresses= -c archive_mode=on -c \"archive_command=${pkgs.pgbackrest}/bin/pgbackrest --stanza=main archive-push %%p\"";
      Restart = "on-failure";
      RestartSec = 5;
    };

    Install.WantedBy = [ "default.target" ];
  };
}
