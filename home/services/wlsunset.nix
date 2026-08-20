# Night light, off by default. Coordinates are Madrid.
{ ... }:
{
  services = {
    wlsunset = {
      enable = false;
      latitude = "40.4";
      longitude = "-3.7";
    };
  };
}
