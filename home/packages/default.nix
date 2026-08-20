# Packages with no config of their own; the configured ones live in home/programs.
{ pkgs, ... }:
with pkgs;
let

  cli = [
    bottom # btm
    fd
    file
    p7zip
    ripgrep # rg
    rsync
    unzip
    wget
  ];

  desktop = [
    grim
    pavucontrol
    wdisplays # monitor layout, Mod+p
    wl-clipboard
  ];

  dev = [
    gnumake
    python3
  ];

  devops = [
    k9s
    kubectl
  ];

in
{
  home = {
    packages = cli ++ desktop ++ dev ++ devops;
  };
}
