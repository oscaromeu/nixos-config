# NetworkManager through rofi: the desktop layer came from a wired machine and
# had no way to pick a wifi.
{ pkgs, ... }:
{
  home = {
    packages = [ pkgs.networkmanager_dmenu ];
  };

  xdg = {
    configFile = {
      "nmdm-config" = {
        target = "networkmanager-dmenu/config.ini";
        text = ''
          [dmenu]
          dmenu_command = ${pkgs.rofi}/bin/rofi -i -dmenu -p red
          highlight = True
          compact = True
          wifi_chars = ▂▄▆█
        '';
      };
    };
  };
}
