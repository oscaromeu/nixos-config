# Removable disks; udiskie in home/services drives it.
{ ... }:
{
  services = {
    udisks2 = {
      enable = true;
    };
  };
}
