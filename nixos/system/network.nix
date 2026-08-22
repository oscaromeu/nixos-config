# The hostname is set in hosts/<machine>/default.nix.
{ ... }:
{
  networking = {
    networkmanager = {
      enable = true;
    };
  };
}
