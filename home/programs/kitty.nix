{
  color,
  theme,
  ...
}:
{
  programs = {
    kitty = {
      enable = true;
      settings = {
        bold_font = "auto";
        bold_italic_font = "auto";
        font_family = "${theme.font-mono}";
        font_size = theme.font-size-term;
        italic_font = "auto";

        # Selecting already copies; ctrl+c copies when there is a selection
        # and interrupts as always when there is not.
        copy_on_select = "yes";

        enable_audio_bell = false;
        enabled_layouts = "tall";
        scrollback_lines = 10000;
        update_check_interval = 0;
        window_padding_width = 5;

        draw_minimal_borders = "yes";
        tab_bar_edge = "top";
        tab_bar_margin_width = 5;
        tab_bar_style = "powerline";
        tab_fade = "0.3 0.6 0.9";
        tab_powerline_style = "angled";
        tab_title_max_length = 12;
      };
      keybindings = {
        "ctrl+c" = "copy_or_interrupt";
      };
      extraConfig = ''
        # ungrabbed: only when the app is not using the mouse itself (nvim keeps its own right-click)
        mouse_map right press ungrabbed paste_from_clipboard

        foreground ${color.h_foreground}
        background ${color.h_background}

        color0 ${color.h_black}
        color1 ${color.h_red}
        color2 ${color.h_green}
        color3 ${color.h_yellow}
        color4 ${color.h_blue}
        color5 ${color.h_purple}
        color6 ${color.h_cyan}
        color7 ${color.h_white}

        color8 ${color.h_bright_black}
        color9 ${color.h_bright_red}
        color10 ${color.h_bright_green}
        color11 ${color.h_bright_yellow}
        color12 ${color.h_bright_blue}
        color13 ${color.h_bright_purple}
        color14 ${color.h_bright_cyan}
        color15 ${color.h_bright_white}

        active_tab_foreground   ${color.h_white}
        active_tab_background   ${color.h_blue}
        active_tab_font_style   bold
        inactive_tab_foreground ${color.h_white}
        inactive_tab_background ${color.h_bright_black}
        inactive_tab_font_style normal
      '';
    };
  };
}
