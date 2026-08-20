{
  pkgs,
  theme,
  ...
}:
with pkgs;
{
  xdg = {
    configFile = {
      "qt5ct-config" = {
        enable = true;
        force = true;
        target = "qt5ct/qt5ct.conf";
        text = ''
          [Appearance]
          color_scheme_path=${libsForQt5.qt5ct}/share/qt5ct/colors/darker.conf
          custom_palette=true
          icon_theme=Papirus-Dark
          standard_dialogs=default
          style=Fusion

          [Fonts]
          fixed="${theme.font},${toString theme.font-size},-1,5,50,0,0,0,0,0,Regular"
          general="${theme.font},${toString theme.font-size},-1,5,50,0,0,0,0,0,Regular"
        '';
      };
      "qt6ct-config" = {
        enable = true;
        force = true;
        target = "qt6ct/qt6ct.conf";
        text = ''
          [Appearance]
          color_scheme_path=${kdePackages.qt6ct}/share/qt6ct/colors/darker.conf
          custom_palette=true
          icon_theme=Papirus-Dark
          standard_dialogs=default
          style=Breeze

          [Fonts]
          fixed="${theme.font},${toString theme.font-size},-1,5,400,0,0,0,0,0,0,0,0,0,0,1,Regular"
          general="${theme.font},${toString theme.font-size},-1,5,400,0,0,0,0,0,0,0,0,0,0,1,Regular"
        '';
      };
    };
  };
}
