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
        "background-color" = color.f_background;
        "border-color" = color.f_blue;
        "border-size" = "3";
        "default-timeout" = "5000"; # 5s
        font = "${theme.font} ${toString theme.font-size}";
        margin = "30";
        padding = "5";
        "progress-color" = "over ${color.f_cyan}";
        "text-color" = color.f_foreground;

        "desktop-entry=snap.slack" = {
          "default-timeout" = "20000"; # 20s
          "border-color" = color.f_green;
        };
      };
    };
  };
}
