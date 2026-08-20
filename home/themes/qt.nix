# The breeze package provides the style; without it Qt apps fall back to Fusion (light).
{ pkgs, ... }:
{
  qt = {
    enable = true;
    platformTheme = {
      name = "qtct";
    };
    style = {
      name = "breeze";
      package = pkgs.kdePackages.breeze;
    };
  };
}
