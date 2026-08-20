# Rotates every 2 min through asset/wallpaper.
{ ... }:
let

  res = "fhd"; # hd/fhd
  wallpaper = "${./../../asset/wallpaper/${res}}";

in
{
  services = {
    wpaperd = {
      enable = true;
      settings = {
        default = {
          duration = "2m";
          path = "${wallpaper}";
          sorting = "ascending";
          apply-shadow = false;
        };
      };
    };
  };
}
