{ ... }:
{
  imports = [
    ./bluetooth.nix
    ./boot.nix
    ./environment.nix
    ./firewall.nix
    ./fonts.nix
    ./graphics.nix
    ./locale.nix
    ./network.nix
    ./nix.nix
    ./security.nix
    ./timezone.nix
    ./users.nix
    ./xdg.nix
    ./zram.nix
  ];
}
