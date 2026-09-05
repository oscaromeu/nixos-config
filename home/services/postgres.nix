{ pkgs, config, ... }:
let

  pg = pkgs.postgresql_17;

  # Provisional until the real data mount is decided (see the rebost doc).
  # The socket lives next to the data dir, not in /run/postgresql: a user
  # unit cannot write there.
  baseDir = "${config.home.homeDirectory}/pg";
  dataDir = "${baseDir}/data";

  # initdb only on first boot: PG_VERSION is the marker it writes last.
  # peer auth on the socket means the unix user is the credential — no
  # passwords anywhere; scram is only the policy if TCP ever gets enabled.
  init = pkgs.writeShellScript "pg-init" ''
    mkdir -p ${baseDir}
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
      # notify: the unit is only "started" once postgres accepts connections,
      # so After=postgres.service really means the database is ready.
      Type = "notify";
      ExecStartPre = "${init}";
      # Socket only. Config passed as flags so the state in dataDir stays
      # data, never configuration.
      ExecStart = "${pg}/bin/postgres -D ${dataDir} -c unix_socket_directories=${baseDir} -c listen_addresses=";
      Restart = "on-failure";
      RestartSec = 5;
    };

    Install.WantedBy = [ "default.target" ];
  };
}
