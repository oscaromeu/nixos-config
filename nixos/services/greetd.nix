# Autologin straight into sway. Logging out drops to tuigreet, which does ask for the
# password; swaylock always does.
{ pkgs, profile, ... }:
{
  services = {
    greetd = {
      enable = true;
      settings = {
        initial_session = {
          command = "sway";
          user = "${profile.name}";
        };
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd sway";
          user = "greeter";
        };
      };
    };
  };
}
