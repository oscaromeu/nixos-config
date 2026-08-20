# GUI only; the radio is enabled in system/bluetooth.nix.
{ ... }:
{
  services = {
    blueman = {
      enable = true;
    };
  };
}
