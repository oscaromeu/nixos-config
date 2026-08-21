# The full desktop, which is what a NixOS host gets. Machines that only want
# the CLI half import ./common.nix alone — see homeConfigurations in flake.nix.
{ ... }:
{
  imports = [
    ./common.nix
    ./desktop.nix
  ];
}
