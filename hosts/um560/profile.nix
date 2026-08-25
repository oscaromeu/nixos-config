# My data, in one place. Modules receive it as the `profile` argument.
{ ... }:
let

  name = "oscar"; # unix user
  fullname = "Oscar Romeu";
  home = "/home/oscar"; # git and the account description
  clipboard = "wl-copy"; # what zellij pipes copies into
  # nixos-config is public, so the email is not in here either. git picks it up
  # from ~/.config/git/identity on the machine — see home/programs/git.nix.
  email = null;
  secrets = ../../secrets/personal.sops.yaml;

  hmTarget = null;

  layout = "es";
  variant = "cat";

  externalOutput = null;

  timezone = "Europe/Madrid";
  locale = "es_ES.UTF-8";

  sshKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGi7BlQxiPqir00iS6I+9iiWuE1i9EmZeWRLqyuAZjCD oscar@mac"
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
    externalOutput
    timezone
    locale
    sshKeys
    ;
}
