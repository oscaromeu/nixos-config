# Everything that works on any box, Linux or macOS: shell, editor, CLI tools.
# The graphical half is in home/desktop.nix, the systemd half in home/linux.nix.
{ profile, alias, ... }:
{
  imports = [
    ./config/fish
    ./packages/common.nix
    ./programs/common.nix
    ./secrets.nix # every profile keeps its git identity out of the repo
  ];

  home = {
    username = profile.name;
    homeDirectory = profile.home;

    # Same rule as system.stateVersion: set once, never changed.
    stateVersion = "26.05";

    shellAliases = alias.abbr;
  };
}
