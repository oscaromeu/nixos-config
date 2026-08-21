# Everything that works on any Linux box, NixOS or not: shell, editor, CLI tools.
# The graphical half is in home/desktop.nix.
{ profile, alias, ... }:
{
  imports = [
    ./config/fish
    ./packages/common.nix
    ./programs/common.nix
    ./services/common.nix
    ./secrets.nix # every profile keeps its git identity out of the repo
  ];

  home = {
    username = profile.name;
    homeDirectory = "/home/${profile.name}";

    # Same rule as system.stateVersion: set once, never changed.
    stateVersion = "26.05";

    shellAliases = alias.abbr;
  };

  # Restart the user services whose unit changed, instead of only warning about it.
  systemd.user.startServices = "sd-switch";
}
