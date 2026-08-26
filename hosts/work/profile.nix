# Work laptop: Ubuntu 24.04 with home-manager standalone. Same shape as user/default.nix.
{ ... }:
let

  name = "oscar-romeu"; # the unix user there, so $HOME matches
  fullname = "Oscar Romeu";
  home = "/home/oscar-romeu";
  clipboard = "wl-copy"; # what zellij pipes copies into

  # nixos-config is public, so the work email is not in here. git picks it up
  # from ~/.config/git/identity on the machine — see home/programs/git.nix.
  email = null;
  secrets = ../../secrets/work.sops.yaml;

  hmTarget = "oscar@work";

  layout = "es";
  variant = "cat";

  externalOutputs = [
    {
      name = "LG Electronics LG HDR 4K 0xC455088D";
      scale = "1.5";
      position = "1920,0";
    }
    {
      name = "LG Electronics LG HDR WFHD 0x0005FC4A";
      scale = "1.0";
      position = "1920,0";
    }
  ];

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
