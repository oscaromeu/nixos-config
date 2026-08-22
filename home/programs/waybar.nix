# Adapted from swayhome, with a battery module for the laptop; no mpd.
{
  color,
  pkgs,
  theme,
  ...
}:
let

  # The distro owns tailscale on the work laptop, so look for it rather than
  # taking it from nix. Machines without it render nothing.
  find = ''
    ts=""
    for c in /usr/bin/tailscale /run/current-system/sw/bin/tailscale "$HOME/.nix-profile/bin/tailscale"; do
      [ -x "$c" ] && ts="$c" && break
    done
  '';

  status = pkgs.writeShellScript "waybar-tailscale-status" (find + ''
    [ -n "$ts" ] || { printf '{"text":""}\n'; exit 0; }
    json=$("$ts" status --json 2>/dev/null) || {
      printf '{"text":"󰦞","class":"off","tooltip":"tailscale sin respuesta"}\n'
      exit 0
    }
    state=$(printf '%s' "$json" | ${pkgs.jq}/bin/jq -r '.BackendState')
    node=$(printf '%s' "$json" | ${pkgs.jq}/bin/jq -r '[.Peer[]? | select(.ExitNode == true) | .HostName] | first // ""')
    if [ "$state" != "Running" ]; then
      printf '{"text":"󰦞","class":"off","tooltip":"tailscale: %s"}\n' "$state"
    elif [ -n "$node" ]; then
      printf '{"text":"󰖂 %s","class":"exit","tooltip":"saliendo por %s"}\n' "$node" "$node"
    else
      printf '{"text":"󰕥","class":"up","tooltip":"tailscale conectado, salida directa"}\n'
    fi
  '');

  # The distro owns NetworkManager too, and the connection only exists where
  # the sops secret put its config.
  findNm = ''
    nm=""
    for c in /usr/bin/nmcli /run/current-system/sw/bin/nmcli; do
      [ -x "$c" ] && nm="$c" && break
    done
  '';

  vpnStatus = pkgs.writeShellScript "waybar-vpn-status" (findNm + ''
    [ -n "$nm" ] || { printf '{"text":""}\n'; exit 0; }
    "$nm" -t -f NAME connection show 2>/dev/null | grep -qx casa || { printf '{"text":""}\n'; exit 0; }
    if "$nm" -t -f NAME,STATE connection show --active 2>/dev/null | grep -qx 'casa:activated'; then
      printf '{"text":"󰚊","class":"up","tooltip":"vpn de casa levantada"}\n'
    else
      printf '{"text":"󰚊","class":"off","tooltip":"vpn de casa parada"}\n'
    fi
  '');

  vpnToggle = pkgs.writeShellScript "waybar-vpn-toggle" (findNm + ''
    [ -n "$nm" ] || exit 0
    if "$nm" -t -f NAME,STATE connection show --active 2>/dev/null | grep -qx 'casa:activated'; then
      "$nm" connection down casa
    else
      # Bringing it up from inside the home LAN sends that subnet into a tunnel
      # whose endpoint is unreachable from there, cutting the machine off.
      if ${pkgs.iproute2}/bin/ip -4 -o addr show | grep -q ' 10\.69\.1\.'; then
        ${pkgs.libnotify}/bin/notify-send 'VPN de casa' 'Ya estas en la red de casa: levantarla te dejaria sin LAN.'
        exit 0
      fi
      "$nm" connection up casa
    fi
    ${pkgs.procps}/bin/pkill -SIGRTMIN+9 waybar
  '');

  menu = pkgs.writeShellScript "waybar-tailscale-menu" (find + ''
    [ -n "$ts" ] || exit 0
    nodes=$("$ts" exit-node list 2>/dev/null | ${pkgs.gawk}/bin/awk '$1 ~ /^100\./ { print $2 }')
    choice=$(printf 'ninguno\n%s\n' "$nodes" | ${pkgs.rofi}/bin/rofi -dmenu -i -p salida)
    [ -n "$choice" ] || exit 0
    if [ "$choice" = "ninguno" ]; then
      "$ts" set --exit-node=
    else
      "$ts" set --exit-node="$choice" --exit-node-allow-lan-access
    fi
    ${pkgs.procps}/bin/pkill -SIGRTMIN+8 waybar
  '');

in
{
  programs = {
    waybar = {
      enable = true;

      # Tied to the sway session, and restarted on its own if it crashes.
      systemd = {
        enable = true;
        targets = [ "sway-session.target" ];
      };

      settings = {
        mainBar = {
          layer = "bottom";
          position = "top";
          height = 34;
          spacing = 6;
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
            "custom/tailscale"
            "custom/vpn"
            "pulseaudio"
            "battery"
            "tray"
          ];
          battery = {
            states = {
              warning = 30;
              critical = 15;
            };
            format = "{icon} {capacity}%";
            format-charging = "󰂄 {capacity}%";
            format-critical = "󰂃 {capacity}%";
            format-icons = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
          };
          "custom/vpn" = {
            exec = "${vpnStatus}";
            return-type = "json";
            interval = 15;
            signal = 9;
            on-click = "${vpnToggle}";
          };
          "custom/tailscale" = {
            exec = "${status}";
            return-type = "json";
            interval = 15;
            signal = 8;
            on-click = "${menu}";
          };
          "sway/mode" = {
            format = "<span style=\"italic\">{}</span>";
          };
          "sway/workspaces" = {
            on-click = "activate";
            sort-by-number = true;
            format = "{name}";
            # Always show 1 to 7; an empty list means every output
            persistent-workspaces = {
              "1" = [ ];
              "2" = [ ];
              "3" = [ ];
              "4" = [ ];
              "5" = [ ];
              "6" = [ ];
              "7" = [ ];
            };
          };
          "bluetooth" = {
            format-on = "󰂯 On";
            format-off = "󰂲 Off";
            format-disabled = "󰂲";
            format-connected = "󰂱 {num_connections} pair";
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
            format = "󰻠 {usage}%";
            tooltip = true;
          };
          "memory" = {
            format = " {}%";
          };
          "temperature" = {
            # Neither box uses thermal_zone0: the um560 has no thermal zones at
            # all, and on the laptop it is not the CPU. waybar walks the list and
            # takes the first path that exists, so one config covers both.
            hwmon-path-abs = [
              "/sys/devices/pci0000:00/0000:00:18.3/hwmon" # um560, Ryzen k10temp
              "/sys/devices/platform/coretemp.0/hwmon" # thinkpad, Intel coretemp
            ];
            input-filename = "temp1_input";
            critical-threshold = 80;
            format-critical = "{icon} {temperatureC}°C";
            format = "{icon} {temperatureC}°C";
            format-icons = [
              "󱃃"
              "󰔏"
              "󱃂"
              "󰸁"
            ];
          };
          "network" = {
            format-wifi = "󰖩 {signalStrength}%";
            format-ethernet = "󰌘 {ipaddr}/{cidr}";
            tooltip-format = "󰌘 {ifname} via {gwaddr}";
            format-linked = "󰌙 {ifname} (No IP)";
            format-disconnected = "󰖪 Off";
            format-alt = "󰌘 {ifname} = {ipaddr}/{cidr}";
            interval = 2;
          };
          "pulseaudio" = {
            format = "{icon} {volume}%  {format_source}";
            format-muted = "󰖁 {volume}%  {format_source}";
            format-bluetooth = "{icon} {volume}%  󰂯 {format_source}";
            format-bluetooth-muted = "󰖁 {icon}  󰂯 {format_source}";
            format-source = "󰍬";
            format-source-muted = "󰍭";
            format-icons = {
              headphone = "󰋋";
              hands-free = "󰋎";
              headset = "󰋎";
              phone = "󰄜";
              portable = "󰄜";
              car = "󰄋";
              default = [
                "󰖀"
                "󰕾"
              ];
            };
          };
        };
      };
      style = ''
        * {
          font-family: ${theme.font}, ${theme.font-symbol};
          font-size: ${toString theme.font-size-bar}px;
          min-height: 0;
        }

        /* Translucent, so the wallpaper shows through. 0.85 keeps the text
           readable over a bright photo; lower it for more see-through. */
        window#waybar {
          background-color: rgba(${color.v_background}, 0.85);
          color: ${color.h_foreground};
        }

        window#waybar.hidden {
          opacity: 0.2;
        }

        /* Keep the first and last module off the screen edges */
        .modules-left {
          padding-left: 6px;
        }

        .modules-right {
          padding-right: 6px;
        }

        button {
          border: none;
          border-radius: 0;
        }

        #workspaces button {
          margin: 3px 2px;
          padding: 0 10px;
          border-radius: 14px;
          color: ${color.h_foreground_muted};
          background: transparent;
          transition: background-color 0.2s ease;
        }

        #workspaces button.empty {
          opacity: 0.45;
        }

        #workspaces button:hover {
          background: ${color.h_black};
          color: ${color.h_foreground};
          box-shadow: none;
        }

        #workspaces button.focused {
          background-color: ${color.h_bright_yellow};
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
          border-radius: 14px;
          background-color: ${color.h_yellow};
          color: ${color.h_background};
        }

        #bluetooth,
        #clock,
        #cpu,
        #memory,
        #battery,
        #custom-tailscale,
        #custom-vpn,
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
        #battery {
          color: ${color.h_bright_white};
        }
        #custom-tailscale {
          color: ${color.h_cyan};
        }
        #custom-tailscale.off {
          color: ${color.h_bright_black};
        }
        #custom-vpn {
          color: ${color.h_green};
        }
        #custom-vpn.off {
          color: ${color.h_bright_black};
        }
        #custom-tailscale.exit {
          color: ${color.h_bright_purple};
          font-weight: bold;
        }
        #battery.warning {
          color: ${color.h_bright_yellow};
        }

        #battery.critical,
        #temperature.critical {
          margin: 3px 2px;
          padding: 0 10px;
          border-radius: 14px;
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
