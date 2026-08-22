# The tray applet for NetworkManager. Owned here rather than by the NixOS
# module, so both machines get it from the same place.
{ ... }:
{
  services = {
    network-manager-applet = {
      enable = true;
    };
  };
}
