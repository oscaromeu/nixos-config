# Only for home-manager on macOS. The system underneath is Apple's; nix owns
# the terminal layer and nothing else.
{ config, ... }:
{
  # Standalone installs its own CLI, same as on the Linux machines.
  programs.home-manager.enable = true;

  # On Linux targets.genericLinux wires the nix paths into the session; on
  # macOS nothing does, and a fish login shell starts without them.
  home.sessionPath = [
    "${config.home.homeDirectory}/.nix-profile/bin"
    "/nix/var/nix/profiles/default/bin"
    "/run/current-system/sw/bin"
  ];
}
