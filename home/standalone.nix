# Only for home-manager outside NixOS. Teaches it that the system underneath
# belongs to another distro.
{ ... }:
{
  # Puts the .desktop files, icons and man pages of nix packages where the host
  # distro looks for them, and sources its environment on login.
  targets.genericLinux.enable = true;

  # On NixOS the CLI comes from the system module; standalone it installs itself.
  programs.home-manager.enable = true;

  # The multi-user installer only teaches bash where the daemon profile is, from
  # /etc/profile.d/nix.sh, so a fish login shell has no nix command at all.
  home.sessionPath = [ "/nix/var/nix/profiles/default/bin" ];
}
