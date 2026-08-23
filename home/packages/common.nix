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

  dev = [
    gnumake
    python3
  ];

  devops = [
    cue
    fluxcd
    go-task # task
    helmfile
    kubeconform
    kubectl
    kubernetes-helm
    makejinja
    talhelper
    yq-go
  ];

in
{
  home = {
    packages = cli ++ dev ++ devops;
  };
}
