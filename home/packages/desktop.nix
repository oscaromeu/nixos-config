{ pkgs, ... }:
with pkgs;
let

  desktop = [
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
