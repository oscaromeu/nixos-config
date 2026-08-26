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
  secrets = ../../secrets/rkw2.sops.yaml;

  hmTarget = "oscar@rkw2";

  layout = "es";
  variant = "cat";

  externalOutputs = [ ];

  timezone = "Europe/Madrid";
  locale = "es_ES.UTF-8";

  sshKeys = [ ];

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
