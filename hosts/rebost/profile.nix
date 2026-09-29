# The NAS: a Turing RK1 with Ubuntu Rockchip, home-manager standalone. Same
# shape as user/default.nix.
{ ... }:
let

  name = "oscar"; # the unix user there, so $HOME matches
  fullname = "Oscar Romeu";
  home = "/home/oscar";
  clipboard = "wl-copy"; # what zellij pipes copies into

  # nixos-config is public, so the email is not in here. git picks it up
  # from ~/.config/git/identity on the machine — see home/programs/git.nix.
  email = null;
  secrets = ../../secrets/rebost.sops.yaml;

  hmTarget = "oscar@rebost";

  layout = "es";
  variant = "cat";

  externalOutputs = [ ];

  timezone = "Europe/Madrid";
  locale = "es_ES.UTF-8";

  # Public halves only. forgejo.nix registers these on the git account.
  sshKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF8fdjfoWtCDNWIomCaPSr23tiAGmSmw2PVed9QEIOpq oscar@20260925"
  ];

in
{
  inherit
    name
    fullname
    home
    clipboard
    email
    secrets
    hmTarget
    layout
    variant
    externalOutputs
    timezone
    locale
    sshKeys
    ;
}
