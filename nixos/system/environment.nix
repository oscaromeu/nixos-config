# Bare minimum, also available to root; day-to-day packages go in home/packages.
{ pkgs, ... }:
{
  environment = {
    systemPackages = with pkgs; [
      curl
      git
      htop
      tree
      unzip
      vim
      wget
    ];
  };
}
