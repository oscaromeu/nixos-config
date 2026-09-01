# Packages with no config of their own; the configured ones live in home/programs.
{ pkgs, pkgsUnstable, ... }:
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
    # Also wrapped inside nvim; on PATH so VS Code's Nix IDE finds it.
    nixd
    nixfmt
    gnumake
    nodejs
    python3
  ];

  devops = [
    # Secrets are edited from any machine; only decryption keys are per-machine.
    age
    sops
    gopass
    pkgsUnstable.yopass
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
