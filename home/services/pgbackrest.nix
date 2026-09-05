{ pkgs, config, ... }:
let

  # Non-root pgbackrest finds nothing by default: config location comes from
  # PGBACKREST_CONFIG and the cipher passphrase from the environment.
  confPath = "${config.xdg.configHome}/pgbackrest/pgbackrest.conf";
  cipherEnv = "${config.xdg.configHome}/pgbackrest/cipher.env";

  backup = type: {
    Unit.Description = "pgBackRest ${type} backup";
    Service = {
      Type = "oneshot";
      Environment = [ "PGBACKREST_CONFIG=${confPath}" ];
      EnvironmentFile = cipherEnv;
      # Idempotent: a no-op once the stanza exists.
      ExecStartPre = "${pkgs.pgbackrest}/bin/pgbackrest --stanza=main stanza-create";
      ExecStart = "${pkgs.pgbackrest}/bin/pgbackrest --stanza=main --type=${type} backup";
    };
  };

in
{
  home.packages = [ pkgs.pgbackrest ];
  home.sessionVariables.PGBACKREST_CONFIG = confPath;

  xdg.configFile."pgbackrest/pgbackrest.conf".text = ''
    [global]
    repo1-path=/data/backups/pgbackrest
    repo1-retention-full=2
    repo1-cipher-type=aes-256-cbc
    log-level-file=off

    [main]
    pg1-path=${config.xdg.stateHome}/postgres/data
    pg1-socket-path=${config.xdg.stateHome}/postgres
  '';

  # The passphrase is the key for every restore.
  sops.secrets."pgbackrest-cipher-env" = {
    path = cipherEnv;
    mode = "0400";
  };

  systemd.user.services.pgbackrest-full = backup "full";
  systemd.user.services.pgbackrest-diff = backup "diff";

  systemd.user.timers.pgbackrest-full = {
    Unit.Description = "Weekly full pgBackRest backup";
    Timer = {
      OnCalendar = "Sun *-*-* 03:00:00";
      Persistent = true;
    };
    Install.WantedBy = [ "timers.target" ];
  };

  systemd.user.timers.pgbackrest-diff = {
    Unit.Description = "Daily diff pgBackRest backup";
    Timer = {
      OnCalendar = "Mon..Sat *-*-* 03:30:00";
      Persistent = true;
    };
    Install.WantedBy = [ "timers.target" ];
  };
}
