# Minisforum UM560 XT — Ryzen 5 5600H, AMD iGPU, 32 GB RAM
{ ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  # Must match the entry name in flake.nix
  networking.hostName = "um560";

  # NixOS version this machine was installed with. Never change it, not even on upgrades.
  system.stateVersion = "26.05";
}
