{
  color,
  theme,
  ...
}:
{
  programs = {
    swaylock = {
      enable = true;
      settings = {
        bs-hl-color = color.h_foreground;
        caps-lock-bs-hl-color = color.h_foreground;
        caps-lock-key-hl-color = color.h_green;
        color = color.h_background;
        inside-caps-lock-color = color.h_background;
        inside-clear-color = color.h_background;
        inside-color = color.h_background;
        inside-ver-color = color.h_background;
        inside-wrong-color = color.h_background;
        key-hl-color = color.h_green;
        layout-bg-color = color.h_background;
        layout-border-color = color.h_background;
        layout-text-color = color.h_blue;
        line-caps-lock-color = color.h_background;
        line-clear-color = color.h_background;
        line-color = color.h_background;
        line-ver-color = color.h_background;
        line-wrong-color = color.h_background;
        ring-caps-lock-color = color.h_yellow;
        ring-clear-color = color.h_foreground;
        ring-color = color.h_cyan;
        ring-ver-color = color.h_blue;
        ring-wrong-color = color.h_red;
        separator-color = color.h_background;
        text-caps-lock-color = color.h_purple;
        text-clear-color = color.h_blue;
        text-color = color.h_foreground;
        text-ver-color = color.h_blue;
        text-wrong-color = color.h_red;
        font = "${theme.font}";
        font-size = theme.font-size-alt;
        disable-caps-lock-text = true;
        ignore-empty-password = true;
        indicator-caps-lock = true;
        indicator-radius = 50;
        indicator-thickness = 10;
      };
    };
  };
}
