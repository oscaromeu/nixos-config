# The personal MacBook Air: macOS, home-manager standalone. Only the terminal
# layer; the desktop is Apple's business.
{ ... }:
let

  name = "oscar";
  fullname = "Oscar Romeu";
  home = "/Users/oscar";
  clipboard = "pbcopy"; # what zellij pipes copies into

  # nixos-config is public, so the email is not in here. git picks it up
  # from ~/.config/git/identity on the machine — see home/programs/git.nix.
  email = null;
  secrets = ../../secrets/air.sops.yaml;

  hmTarget = "oscar@air";

  layout = "es";
  variant = "cat";

  externalOutput = null;

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
    externalOutput
    timezone
    locale
    sshKeys
    ;
}
