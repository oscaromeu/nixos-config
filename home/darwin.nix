# Only for home-manager on macOS. The system underneath is Apple's; nix owns
# the terminal layer and nothing else.
{ ... }:
{
  # Standalone installs its own CLI, same as on the Linux machines.
  programs.home-manager.enable = true;
}
