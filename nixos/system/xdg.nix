# Portals: file dialogs and screen sharing for apps under Wayland.
{ pkgs, ... }:
{
  xdg = {
    portal = {
      enable = true;
      wlr = {
        enable = true;
      };
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
      ];
    };
  };
}
