{
  pkgs,
  ...
}:
with pkgs;
{
  services = {
    playerctld = {
      enable = true;
      package = playerctl;
    };
  };
}
