# Annotated screenshots, launched from the bar. The grim adapter captures
# without any portal, and its own tray icon is off — the bar button is enough.
{ pkgs, ... }:
{
  home = {
    packages = [ pkgs.flameshot ];
  };

  xdg = {
    configFile = {
      "flameshot-config" = {
        target = "flameshot/flameshot.ini";
        text = ''
          [General]
          disabledTrayIcon=true
          showStartupLaunchMessage=false
          useGrimAdapter=true
        '';
      };
    };
  };
}
