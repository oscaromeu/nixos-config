# System side only: session registration, security wrappers and sway on PATH for
# greetd. Keybindings, colours and the bar are in home/wayland/sway.nix.
{ ... }:
{
  programs = {
    sway = {
      enable = true;
      wrapperFeatures = {
        gtk = true;
      };
    };
  };
}
