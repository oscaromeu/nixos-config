{
  color,
  theme,
  ...
}:
{
  programs = {
    zathura = {
      enable = true;
      options = {
        adjust-open = "width";
        font = "${theme.font} ${toString theme.font-size}";
        guioptions = "s";
        pages-per-row = 1;
        recolor = true;
        scroll-step = 50;
        completion-bg = color.r_background;
        completion-fg = color.r_foreground;
        completion-group-bg = color.r_background;
        completion-group-fg = color.r_foreground;
        completion-highlight-bg = color.r_blue;
        completion-highlight-fg = color.r_foreground;
        default-bg = color.r_background;
        default-fg = color.r_foreground;
        highlight-active-color = color.r_purple;
        highlight-color = color.rh_blue;
        highlight-fg = color.rh_foreground;
        index-active-bg = color.r_blue;
        index-active-fg = color.r_foreground;
        index-bg = color.r_background;
        index-fg = color.r_foreground;
        inputbar-bg = color.r_background;
        inputbar-fg = color.r_foreground;
        notification-bg = color.r_background;
        notification-error-bg = color.r_background;
        notification-error-fg = color.r_red;
        notification-fg = color.r_foreground;
        notification-warning-bg = color.r_background;
        notification-warning-fg = color.r_yellow;
        recolor-darkcolor = color.r_foreground;
        recolor-lightcolor = color.r_background;
        render-loading-bg = color.r_background;
        render-loading-fg = color.r_foreground;
        scrollbar-bg = color.r_black;
        scrollbar-fg = color.r_foreground;
        statusbar-bg = color.r_background;
        statusbar-fg = color.r_foreground;
        selection-clipboard = "clipboard";
        statusbar-home-tilde = true;
        scroll-page-aware = true;
        window-title-basename = true;
      };
    };
  };
}
