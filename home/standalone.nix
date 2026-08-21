# Only for home-manager outside NixOS. Teaches it that the system underneath
# belongs to another distro.
{ ... }:
{
  # Puts the .desktop files, icons and man pages of nix packages where the host
  # distro looks for them, and sources its environment on login.
  targets.genericLinux.enable = true;

  # On NixOS the CLI comes from the system module; standalone it installs itself.
  programs.home-manager.enable = true;
}
