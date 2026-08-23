{
  pkgs,
  config,
  color,
  theme,
  ...
}:
with pkgs;
{
  programs = {
    rofi = {
      enable = true;
      font = "${theme.font} ${toString theme.font-size-menu}";
      package = rofi;
      extraConfig = {
        case-sensitive = false;
        display-drun = "Apps";
        show-icons = true;
        icon-theme = theme.icon;
        modi = [
          "drun"
          "filebrowser"
          "run"
        ];
      };
      plugins = [
        rofi-file-browser
        rofi-pulse-select
        rofi-systemd
      ];
      theme =
        let
          mkLiteral = config.lib.formats.rasi.mkLiteral;
        in
        {
          "*" = {
            bg = mkLiteral color.h_background;
            bg-alt = mkLiteral color.h_background_alt;
            fg = mkLiteral color.h_foreground;
            fg-muted = mkLiteral color.h_foreground_muted;
            ac = mkLiteral color.h_blue;
            background-color = mkLiteral "transparent";
            text-color = mkLiteral "@fg";
          };

          "#window" = {
            transparency = "real";
            background-color = mkLiteral "@bg";
            location = mkLiteral "center";
            width = mkLiteral "38%";
            border = mkLiteral "2px";
            border-color = mkLiteral "@bg-alt";
            border-radius = mkLiteral "16px";
            padding = mkLiteral "16px";
          };

          "#mainbox" = {
            children = mkLiteral "[ inputbar, listview ]";
            spacing = mkLiteral "12px";
          };

          "#inputbar" = {
            children = mkLiteral "[ prompt, entry ]";
            background-color = mkLiteral "@bg-alt";
            border-radius = mkLiteral "10px";
            padding = mkLiteral "10px 14px";
            spacing = mkLiteral "8px";
          };

          "#prompt" = {
            text-color = mkLiteral "@ac";
          };

          "#entry" = {
            placeholder = "Buscar…";
            placeholder-color = mkLiteral "@fg-muted";
            blink = mkLiteral "true";
          };

          "#listview" = {
            columns = mkLiteral "1";
            lines = mkLiteral "8";
            spacing = mkLiteral "4px";
            cycle = mkLiteral "true";
            dynamic = mkLiteral "true";
            scrollbar = mkLiteral "false";
          };

          "#element" = {
            padding = mkLiteral "8px 10px";
            spacing = mkLiteral "10px";
            border-radius = mkLiteral "10px";
          };

          "#element-icon" = {
            size = mkLiteral "28px";
          };

          "#element-text" = {
            text-color = mkLiteral "inherit";
            vertical-align = mkLiteral "0.5";
          };

          "#element selected" = {
            background-color = mkLiteral "@ac";
            text-color = mkLiteral "@bg";
          };
        };
    };
  };
}
