{
  color,
  theme,
  ...
}:
{
  services = {
    mako = {
      enable = true;
      settings = {
        backgroundColor = color.f_background;
        borderColor = color.f_blue;
        borderSize = "3";
        defaultTimeout = "5000"; # 5s
        font = "${theme.font} ${toString theme.font-size}";
        margin = "30";
        padding = "5";
        progressColor = "over ${color.f_cyan}";
        textColor = color.f_foreground;
      };
    };
  };
}
