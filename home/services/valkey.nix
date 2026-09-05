{ pkgs, config, ... }:
let

  # Only forgejo's cache and sessions live here, so nothing is worth
  # persisting and the socket never leaves the machine.
  dataDir = "${config.home.homeDirectory}/valkey";

  conf = pkgs.writeText "valkey.conf" ''
    bind 127.0.0.1
    port 6379
    dir ${dataDir}
    save ""
    appendonly no
  '';

in
{
  # valkey-cli, for the PONG check and poking at keys.
  home.packages = [ pkgs.valkey ];

  systemd.user.services.valkey = {
    Unit.Description = "Valkey cache";

    Service = {
      ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p ${dataDir}";
      ExecStart = "${pkgs.valkey}/bin/valkey-server ${conf}";
      Restart = "on-failure";
      RestartSec = 5;
    };

    Install.WantedBy = [ "default.target" ];
  };
}
