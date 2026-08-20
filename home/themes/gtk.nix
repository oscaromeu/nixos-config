{
  pkgs,
  theme,
  ...
}:
with pkgs;
{
  gtk = {
    enable = true;
    font = {
      name = theme.font;
      size = theme.font-size;
    };
    theme = {
      name = theme.theme;
      package = kdePackages.breeze-gtk;
    };
    iconTheme = {
      name = theme.icon;
      package = papirus-icon-theme;
    };
    cursorTheme = {
      name = theme.cursor;
      size = theme.cursor-size;
    };
    gtk2 = {
      extraConfig = ''
        gtk-menu-images = 0;
        gtk-button-images = 0;
        gtk-xft-antialias = 1;
        gtk-xft-hinting = 1;
        gtk-xft-hintstyle = "hintslight";
        gtk-xft-rgba = "none";
        gtk-xft-dpi = 98304;
      '';
    };
    gtk3 = {
      extraConfig = {
        gtk-application-prefer-dark-theme = "true";
        gtk-xft-antialias = 1;
        gtk-xft-hinting = 1;
        gtk-xft-hintstyle = "hintslight";
        gtk-xft-rgba = "none";
        gtk-xft-dpi = 98304;
        gtk-overlay-scrolling = "true";
        gtk-key-theme-name = "Default";
        gtk-menu-images = "false";
        gtk-button-images = "false";
      };
      extraCss = ''
        .titlebar,
        .titlebar .background
        {
          border-radius: 0;
        }

        decoration
        {
          box-shadow: none;
        }

        decoration:backdrop
        {
          box-shadow: none;
        }
      '';
    };
    gtk4 = {
      extraConfig = {
        gtk-application-prefer-dark-theme = "true";
        gtk-xft-antialias = 1;
        gtk-xft-hinting = 1;
        gtk-xft-hintstyle = "hintslight";
        gtk-xft-rgba = "none";
        gtk-xft-dpi = 98304;
        gtk-overlay-scrolling = "true";
      };
      extraCss = ''
        .titlebar,
        .titlebar .background
        {
          border-radius: 0;
        }

        decoration
        {
          box-shadow: none;
        }

        decoration:backdrop
        {
          box-shadow: none;
        }
      '';
    };
  };
}
