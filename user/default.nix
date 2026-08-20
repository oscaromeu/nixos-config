# My data, in one place. Modules receive it as the `profile` argument.
{ ... }:
let

  name = "oscar"; # unix user
  fullname = "Oscar Romeu"; # git and the account description
  email = "oscar@example.com"; # TODO: real email, git uses it

  layout = "es";
  variant = "cat";

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
    email
    layout
    variant
    timezone
    locale
    sshKeys
    ;
}
