# Adapted from swayhome for a desktop: no battery, brightness or mpd modules.
{
  color,
  theme,
  ...
}:
{
  programs = {
    waybar = {
      enable = true;
      settings = {
        mainBar = {
          layer = "bottom";
          position = "top";
          height = 30;
          spacing = 6;
          # margins are what make the bar float
          margin-top = 6;
          margin-left = 12;
          margin-right = 12;
          modules-left = [
            "sway/workspaces"
            "sway/mode"
          ];
          modules-center = [
            "clock"
          ];
          modules-right = [
            "cpu"
            "memory"
            "temperature"
            "bluetooth"
            "network"
            "pulseaudio"
            "tray"
          ];
          "sway/mode" = {
            format = "<span style=\"italic\">{}</span>";
          };
          "sway/workspaces" = {
            on-click = "activate";
            sort-by-number = true;
            format = "{name} {icon}";
            format-icons = {
              "1" = "";
              "2" = "";
              "3" = "";
              "4" = "";
              "5" = "";
              "6" = "";
              "7" = "";
              "8" = "";
              "9" = "";
              "10" = "";
            };
          };
          "bluetooth" = {
            format-on = "On 󰂯";
            format-off = "Off 󰂲";
            format-disabled = "󰂲";
            format-connected = "{num_connections} pair 󰂱";
            tooltip-format = "{controller_alias}\t{controller_address}";
            tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{device_enumerate}";
            tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
          };
          "tray" = {
            icon-size = 13;
            spacing = 8;
          };
          "clock" = {
            interval = 60;
            tooltip = true;
            format = "{:%R }";
            format-alt = "{:%R | %A, %d %B %Y }";
            tooltip-format = "<tt><small>{calendar}</small></tt>";
            calendar = {
              mode = "year";
              mode-mon-col = 3;
              weeks-pos = "right";
              on-scroll = 1;
              format = {
                months = "<span color='${color.h_bright_blue}'><b>{}</b></span>";
                days = "<span color='${color.h_bright_white}'>{}</span>";
                weeks = "<span color='${color.h_bright_cyan}'><b>W{}</b></span>";
                weekdays = "<span color='${color.h_bright_yellow}'><b>{}</b></span>";
                today = "<span color='${color.h_bright_green}'><b><u>{}</u></b></span>";
              };
            };
            actions = {
              on-click-right = "mode";
            };
          };
          "cpu" = {
            format = "{usage}% ";
            tooltip = true;
          };
          "memory" = {
            format = "{}% ";
          };
          "temperature" = {
            critical-threshold = 80;
            format-critical = "{temperatureC}°C {icon}";
            format = "{temperatureC}°C {icon}";
            format-icons = [
              ""
              ""
              ""
              ""
            ];
          };
          "network" = {
            format-wifi = "{signalStrength}% ";
            format-ethernet = "{ipaddr}/{cidr} ";
            tooltip-format = "{ifname} via {gwaddr} ";
            format-linked = "{ifname} (No IP) ";
            format-disconnected = "Off ";
            format-alt = "{ifname} = {ipaddr}/{cidr} ";
            interval = 2;
          };
          "pulseaudio" = {
            format = "{volume}% {icon}    {format_source}";
            format-muted = "{volume}%     {format_source}";
            format-bluetooth = "{volume}% {icon}    󰂯 {format_source}";
            format-bluetooth-muted = " {icon}    󰂯 {format_source}";
            format-source = "{volume}% ";
            format-source-muted = "{volume}% ";
            format-icons = {
              headphone = "";
              hands-free = "";
              headset = "";
              phone = "";
              portable = "";
              car = "";
              default = [
                ""
                ""
              ];
            };
          };
        };
      };
      style = ''
        * {
          font-family: ${theme.font}, ${theme.font-symbol};
          font-size: ${toString theme.font-size-alt}px;
          min-height: 0;
        }

        /* The window is transparent; what shows are the three islands */
        window#waybar {
          background: transparent;
          color: ${color.h_foreground};
        }

        window#waybar.hidden {
          opacity: 0.2;
        }

        .modules-left,
        .modules-center,
        .modules-right {
          background-color: ${color.h_background};
          border: 1px solid ${color.h_black};
          border-radius: 14px;
          padding: 0 4px;
        }

        button {
          border: none;
          border-radius: 0;
        }

        #workspaces button {
          margin: 3px 2px;
          padding: 0 10px;
          border-radius: 10px;
          color: ${color.h_foreground_muted};
          background: transparent;
          transition: background-color 0.2s ease;
        }

        #workspaces button:hover {
          background: ${color.h_black};
          color: ${color.h_foreground};
          box-shadow: none;
        }

        #workspaces button.focused {
          background-color: ${color.h_blue};
          color: ${color.h_background};
        }

        #workspaces button.urgent {
          background-color: ${color.h_red};
          color: ${color.h_background};
        }

        /* sway mode (resize...): orange pill, meant to be noticed */
        #mode {
          margin: 3px 2px;
          padding: 0 10px;
          border-radius: 10px;
          background-color: ${color.h_yellow};
          color: ${color.h_background};
        }

        #bluetooth,
        #clock,
        #cpu,
        #memory,
        #network,
        #pulseaudio,
        #temperature,
        #tray {
          padding: 0 10px;
        }

        /* One accent per module, all from the Breeze palette */
        #clock {
          color: ${color.h_bright_white};
          font-weight: bold;
        }
        #cpu {
          color: ${color.h_bright_blue};
        }
        #memory {
          color: ${color.h_bright_purple};
        }
        #temperature {
          color: ${color.h_bright_yellow};
        }
        #bluetooth {
          color: ${color.h_blue};
        }
        #network {
          color: ${color.h_bright_cyan};
        }
        #pulseaudio {
          color: ${color.h_bright_green};
        }

        #temperature.critical {
          margin: 3px 2px;
          padding: 0 10px;
          border-radius: 10px;
          background-color: ${color.h_red};
          color: ${color.h_background};
        }

        #tray > .passive {
          -gtk-icon-effect: dim;
        }

        #tray > .needs-attention {
          -gtk-icon-effect: highlight;
        }

        tooltip {
          background: ${color.h_background};
          border: 1px solid ${color.h_bright_black};
          border-radius: 10px;
        }

        tooltip label {
          color: ${color.h_foreground};
        }
      '';
    };
  };
}
