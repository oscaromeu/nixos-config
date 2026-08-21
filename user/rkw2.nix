# The NAS: a Turing RK1 with Ubuntu Rockchip, home-manager standalone. Same
# shape as user/default.nix.
{ ... }:
let

  name = "oscar"; # the unix user there, so $HOME matches
  fullname = "Oscar Romeu";

  # nixos-config is public, so the email is not in here. git picks it up
  # from ~/.config/git/identity on the machine — see home/programs/git.nix.
  email = null;
  secrets = ../secrets/rkw2.sops.yaml;

  layout = "es";
  variant = "cat";

  timezone = "Europe/Madrid";
  locale = "es_ES.UTF-8";

  sshKeys = [ ];

in
{
  inherit
    name
    fullname
    email
    secrets
    layout
    variant
    timezone
    locale
    sshKeys
    ;
}
