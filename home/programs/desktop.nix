{ ... }:
{
  imports = [
    ./cava.nix # needs an audio server
    ./firefox.nix
    ./foot.nix
    ./imv.nix
    ./kitty.nix
    ./mpv.nix
    ./rofi.nix
    ./swaylock.nix
    ./waybar.nix
    ./zathura.nix
  ];
}
