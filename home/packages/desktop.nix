{ pkgs, ... }:
with pkgs;
let

  desktop = [
    # Falls back to logind when it cannot write sysfs, which is the case on a
    # distro that leaves the backlight file owned by root.
    brightnessctl
    grim
    pavucontrol
    wdisplays # monitor layout, Mod+p
    wl-clipboard
  ];

in
{
  home = {
    packages = desktop;
  };
}
