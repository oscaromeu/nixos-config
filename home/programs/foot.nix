# Alternative terminal; kitty is the main one.
{
  color,
  theme,
  ...
}:
{
  programs = {
    foot = {
      enable = true;
      settings = {
        main = {
          font = "${theme.font-mono}:size=${toString theme.font-size-term}";
          dpi-aware = "no";
          pad = "15x15 center";
        };
        mouse = {
          hide-when-typing = "yes";
        };
        colors = {
          alpha = 1.0;
          foreground = color.foreground;
          background = color.background;
          regular0 = color.black;
          regular1 = color.red;
          regular2 = color.green;
          regular3 = color.yellow;
          regular4 = color.blue;
          regular5 = color.purple;
          regular6 = color.cyan;
          regular7 = color.white;
          bright0 = color.bright_black;
          bright1 = color.bright_red;
          bright2 = color.bright_green;
          bright3 = color.bright_yellow;
          bright4 = color.bright_blue;
          bright5 = color.bright_purple;
          bright6 = color.bright_cyan;
          bright7 = color.bright_white;
        };
      };
    };
  };
}
