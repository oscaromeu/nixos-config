# Lock at 15 min, screen off at 20. No auto-suspend: it is a desktop I reach over SSH.
{
  pkgs,
  ...
}:
with pkgs;
let

  lockcommand = "${swaylock}/bin/swaylock --daemonize";
  unlockcommand = "${procps}/bin/pkill -SIGUSR1 swaylock";

  timeoutcommand = "${sway}/bin/swaymsg \"output * dpms off\"";
  resumecommand = "${sway}/bin/swaymsg \"output * dpms on\"";

in
{
  services = {
    swayidle = {
      enable = true;
      systemdTargets = [ "sway-session.target" ];
      events = {
        before-sleep = lockcommand;
        lock = lockcommand;
        unlock = unlockcommand;
        after-resume = resumecommand;
      };
      timeouts = [
        {
          timeout = 900; # 15m
          command = lockcommand;
        }
        {
          timeout = 1200; # 20m
          command = timeoutcommand;
          resumeCommand = resumecommand;
        }
      ];
    };
  };
}
