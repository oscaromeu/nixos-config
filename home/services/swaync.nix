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
          --noti-bg: ${color.h_background};
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

        .blank-window {
          background: transparent;
        }

        .control-center {
          background: rgba(${color.v_background}, 0.92);
          border: 1px solid rgba(${color.v_foreground}, 0.08);
          border-radius: 16px;
          box-shadow: 0 8px 24px rgba(0, 0, 0, 0.45);
          margin: 8px;
          padding: 10px;
        }

        .control-center-list {
          background: transparent;
        }

        .widget-title {
          margin: 2px 4px 10px;
        }

        .widget-title > label {
          font-size: 18px;
          font-weight: 700;
          color: ${color.h_foreground};
        }

        .widget-title > button {
          background: rgba(${color.v_background_alt}, 1.0);
          border: 1px solid rgba(${color.v_foreground}, 0.08);
          border-radius: 10px;
          padding: 4px 14px;
          color: ${color.h_foreground};
          box-shadow: none;
        }

        .widget-title > button:hover {
          background: rgba(${color.v_blue}, 0.25);
          border-color: rgba(${color.v_blue}, 0.5);
        }

        .widget-dnd {
          margin: 0 4px 10px;
          font-size: 14px;
          color: ${color.h_foreground_muted};
        }

        .widget-dnd > switch {
          border-radius: 999px;
          background: rgba(${color.v_background_alt}, 1.0);
          border: 1px solid rgba(${color.v_foreground}, 0.12);
          box-shadow: none;
        }

        .widget-dnd > switch:checked {
          background: ${color.h_blue};
        }

        .widget-dnd > switch slider {
          border-radius: 999px;
          background: ${color.h_foreground};
          border: none;
          box-shadow: 0 1px 3px rgba(0, 0, 0, 0.4);
        }

        .notification-row {
          outline: none;
          margin: 0;
          padding: 0;
        }

        .notification {
          border-radius: 12px;
          margin: 4px 2px;
          box-shadow: 0 2px 8px rgba(0, 0, 0, 0.35);
          border: 1px solid rgba(${color.v_foreground}, 0.08);
          background: rgba(${color.v_background_alt}, 0.98);
          padding: 0;
        }

        .notification.critical {
          border: 1px solid rgba(${color.v_red}, 0.8);
        }

        .notification-content {
          background: transparent;
          padding: 8px;
          border-radius: 12px;
        }

        .notification-default-action,
        .notification-action {
          padding: 4px;
          margin: 0;
          box-shadow: none;
          background: transparent;
          border: none;
          color: ${color.h_foreground};
          border-radius: 12px;
        }

        .notification-default-action:hover,
        .notification-action:hover {
          background: rgba(${color.v_blue}, 0.15);
        }

        .notification-action {
          border-top: 1px solid rgba(${color.v_foreground}, 0.08);
          border-radius: 0;
        }

        .notification-action:first-child {
          border-bottom-left-radius: 12px;
        }

        .notification-action:last-child {
          border-bottom-right-radius: 12px;
        }

        .close-button {
          background: rgba(${color.v_foreground}, 0.1);
          color: ${color.h_foreground};
          text-shadow: none;
          padding: 0;
          border-radius: 999px;
          margin-top: 8px;
          margin-right: 8px;
          box-shadow: none;
          border: none;
          min-width: 22px;
          min-height: 22px;
        }

        .close-button:hover {
          background: ${color.h_red};
          color: ${color.h_bright_white};
        }

        .summary {
          font-size: 14px;
          font-weight: 700;
          color: ${color.h_foreground};
          background: transparent;
        }

        .time {
          font-size: 12px;
          color: ${color.h_foreground_muted};
          background: transparent;
          margin-right: 24px;
        }

        .body {
          font-size: 13px;
          color: ${color.h_foreground_muted};
          background: transparent;
        }

        .image {
          border-radius: 8px;
          margin-right: 8px;
        }

        progressbar {
          border-radius: 999px;
        }

        progressbar > trough {
          background: rgba(${color.v_foreground}, 0.1);
          border-radius: 999px;
        }

        progressbar > trough > progress {
          background: ${color.h_blue};
          border-radius: 999px;
        }

        .notification-group {
          margin: 2px;
        }

        .notification-group-headers {
          color: ${color.h_foreground};
          font-weight: 700;
        }

        .notification-group-collapse-button,
        .notification-group-close-all-button {
          background: rgba(${color.v_background_alt}, 1.0);
          color: ${color.h_foreground};
          border: 1px solid rgba(${color.v_foreground}, 0.08);
          border-radius: 10px;
          box-shadow: none;
          margin: 2px;
        }

        .notification-group-collapse-button:hover,
        .notification-group-close-all-button:hover {
          background: rgba(${color.v_blue}, 0.25);
        }
      '';
    };
  };
}
