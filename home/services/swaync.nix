{
  color,
  theme,
  ...
}:
{
  services = {
    swaync = {
      enable = true;
      settings = {
        positionX = "right";
        positionY = "top";
        layer = "overlay";
        layer-shell = true;
        control-center-layer = "top";
        control-center-width = 460;
        control-center-height = 700;
        notification-window-width = 460;
        notification-grouping = true;
        keyboard-shortcuts = true;
        relative-timestamps = true;
        image-visibility = "when-available";
        transition-time = 200;
        hide-on-clear = true;
        hide-on-action = true;
        text-empty = "Sin notificaciones";
        timeout = 10;
        timeout-low = 5;
        timeout-critical = 0;
        widgets = [
          "title"
          "dnd"
          "notifications"
        ];
      };
      style = ''
        :root {
          --cc-bg: rgba(${color.v_background}, 0.92);
          --noti-bg: ${color.v_background};
          --noti-bg-alpha: 0.95;
          --noti-bg-darker: ${color.h_background};
          --noti-bg-hover: ${color.h_background_alt};
          --noti-bg-focus: ${color.h_background_alt};
          --noti-close-bg: ${color.h_background_alt};
          --noti-close-bg-hover: ${color.h_red};
          --text-color: ${color.h_foreground};
          --text-color-disabled: ${color.h_foreground_muted};
          --bg-selected: ${color.h_blue};
        }

        * {
          font-family: ${theme.font}, ${theme.font-symbol};
        }
      '';
    };
  };
}
