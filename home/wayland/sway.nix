# Adapted from swayhome. Brightness works through logind, so it needs no
# udev rule on machines where the sysfs file belongs to root.
{
  lib,
  pkgs,
  color,
  profile,
  theme,
  ...
}:
with lib;
with pkgs;
let

  mod4 = "Mod4"; # Super
  opacity = "1.0";

  # vim-style navigation
  left = "h";
  down = "j";
  up = "k";
  right = "l";

  window_bg_color = color.h_background;
  accent_bg_color = color.h_blue;
  accent_fg_color = color.h_foreground;
  urgent_bg_color = color.h_red;
  urgent_fg_color = color.h_foreground;
  view_bg_color = color.h_bright_black;
  view_fg_color = color.h_foreground;

  # screen recording
  screenrec = "wl-screenrec";
  recorder = "${wl-screenrec}/bin/${screenrec}";
  opt = "--low-power=off";
  filename = "$(${coreutils-full}/bin/date +%Y%m%d_%Hh%Mm%Ss_@${profile.name}";
  vfilename = "$(${xdg-user-dirs}/bin/xdg-user-dir VIDEOS)/record/${filename}.mp4)";

in
{
  wayland = {
    windowManager = {
      sway = {
        enable = true;
        config = {
          modifier = "${mod4}";
          # waybar runs as a user service instead, so systemd restarts it
          # if it dies: see home/programs/waybar.nix
          bars = [ ];
          focus = {
            forceWrapping = false;
            followMouse = false;
          };
          fonts = {
            names = [ "${theme.font}" ];
            size = toString theme.font-size;
          };
          gaps = {
            inner = 20;
          };
          # Left of the space on the laptop panel, the rest on the external
          # monitor when there is one; names that do not exist are ignored, so
          # the same block is harmless on the desktop.
          workspaceOutputAssign = [
            { workspace = "1"; output = "eDP-1"; }
            { workspace = "2"; output = "eDP-1"; }
            { workspace = "3"; output = "eDP-1"; }
            { workspace = "4"; output = "HDMI-A-1 eDP-1"; }
            { workspace = "5"; output = "HDMI-A-1 eDP-1"; }
            { workspace = "6"; output = "HDMI-A-1 eDP-1"; }
            { workspace = "7"; output = "HDMI-A-1 eDP-1"; }
          ];
          startup = [
            { command = "${kitty}/bin/kitty"; }
          ];
          input = {
            "type:keyboard" = {
              xkb_layout = "${profile.layout}";
              xkb_variant = "${profile.variant}";
            };

            "type:touchpad" = {
              dwt = "enabled";
              tap = "enabled";
              natural_scroll = "enabled";
              middle_emulation = "enabled";
            };

            "type:mouse" = {
              natural_scroll = "disabled";
            };
          };
          # No bg here on purpose: wpaperd owns the wallpaper, and two
          # providers means whichever layer lands on top wins.
          seat = {
            "*" = {
              hide_cursor = "3000";
            };
          };
          window = {
            border = 3;
            titlebar = false;
            commands = [
              {
                command = "opacity ${opacity}, border pixel 3, inhibit_idle fullscreen";
                criteria = {
                  class = ".*";
                };
              }
              {
                command = "opacity ${opacity}, border pixel 3, inhibit_idle fullscreen";
                criteria = {
                  app_id = ".*";
                };
              }
              {
                command = "floating enable, resize set 900 500";
                criteria = {
                  app_id = "mpv";
                };
              }
              {
                command = "floating enable, sticky enable";
                criteria = {
                  title = "Picture-in-Picture";
                };
              }
              {
                command = "floating enable, sticky enable";
                criteria = {
                  title = ".*Sharing Indicator.*";
                };
              }
            ];
          };
          assigns = {
            "2" = [
              { app_id = "firefox"; }
            ];
            "3" = [
              { app_id = "vscode"; }
              { app_id = ".*zed.*"; }
            ];
          };
          floating = {
            modifier = "${mod4}";
            border = 3;
            titlebar = false;
            criteria = [
              { app_id = ".*blueman-manager-wrapped"; }
              { app_id = ".*wl_mirror"; }
              { app_id = ".*zathura"; }
              { app_id = "imv"; }
              { app_id = "mpv"; }
              { app_id = "system-config-printer"; }
              { app_id = "wdisplays"; }
              { app_id = "xdg-desktop-portal-gtk"; }
            ];
          };
          keybindings = mkOptionDefault {
            "${mod4}+d" = "exec ${rofi}/bin/rofi -show drun";
            "${mod4}+y" = "exec ${rofi-bluetooth}/bin/rofi-bluetooth";
            "${mod4}+c" =
              "exec ${cliphist}/bin/cliphist list | ${rofi}/bin/rofi -dmenu | ${cliphist}/bin/cliphist decode | ${wl-clipboard}/bin/wl-copy";
            "${mod4}+x" =
              "exec ${rofi}/bin/rofi -show menu -modi 'menu:${rofi-power-menu}/bin/rofi-power-menu --no-symbols'";
            "${mod4}+g" = "exec ${rofi}/bin/rofi -show filebrowser";
            "${mod4}+e" = "exec ${kitty}/bin/kitty ${yazi}/bin/yazi";
            "${mod4}+m" = "exec ${bemoji}/bin/bemoji";
            "${mod4}+n" = "exec ${wl-color-picker}/bin/wl-color-picker clipboard";
            # screen mirror, for presentations
            "${mod4}+o" = "exec ${wl-mirror}/bin/wl-present mirror";
            "${mod4}+p" = "exec ${wdisplays}/bin/wdisplays";

            "${mod4}+Return" = "exec ${kitty}/bin/kitty";

            "${mod4}+Escape" = "exec ${swaylock}/bin/swaylock";

            # modes are defined in `modes` below
            "${mod4}+r" = "mode resize";
            "${mod4}+u" = "mode audio";
            "Print" = "mode printscreen";
            "Shift+Print" = "mode record";

            "${mod4}+bracketright" = "workspace next";
            "${mod4}+bracketleft" = "workspace prev";
            "${mod4}+period" = "workspace next";
            "${mod4}+comma" = "workspace prev";
            "${mod4}+Tab" = "workspace next";
            "${mod4}+Shift+Tab" = "workspace prev";

            "${mod4}+1" = "workspace number 1";
            "${mod4}+2" = "workspace number 2";
            "${mod4}+3" = "workspace number 3";
            "${mod4}+4" = "workspace number 4";
            "${mod4}+5" = "workspace number 5";
            "${mod4}+6" = "workspace number 6";
            "${mod4}+7" = "workspace number 7";

            "${mod4}+Shift+period" = "move container to workspace next; workspace next";
            "${mod4}+Shift+comma" = "move container to workspace prev; workspace prev";

            "${mod4}+Shift+1" = "move container to workspace number 1";
            "${mod4}+Shift+2" = "move container to workspace number 2";
            "${mod4}+Shift+3" = "move container to workspace number 3";
            "${mod4}+Shift+4" = "move container to workspace number 4";
            "${mod4}+Shift+5" = "move container to workspace number 5";
            "${mod4}+Shift+6" = "move container to workspace number 6";
            "${mod4}+Shift+7" = "move container to workspace number 7";

            "${mod4}+${left}" = "focus left";
            "${mod4}+${down}" = "focus down";
            "${mod4}+${up}" = "focus up";
            "${mod4}+${right}" = "focus right";

            "${mod4}+Ctrl+${left}" = "move workspace to output left";
            "${mod4}+Ctrl+${down}" = "move workspace to output down";
            "${mod4}+Ctrl+${up}" = "move workspace to output up";
            "${mod4}+Ctrl+${right}" = "move workspace to output right";

            "${mod4}+Shift+${left}" = "move left";
            "${mod4}+Shift+${down}" = "move down";
            "${mod4}+Shift+${up}" = "move up";
            "${mod4}+Shift+${right}" = "move right";

            # volume
            "XF86AudioRaiseVolume" = "exec ${wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%+";
            "XF86AudioLowerVolume" = "exec ${wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-";
            "XF86AudioMute" = "exec ${wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";

            # mic
            "${mod4}+XF86AudioRaiseVolume" =
              "exec ${wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 2%+";
            "${mod4}+XF86AudioLowerVolume" =
              "exec ${wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 2%-";
            "${mod4}+XF86AudioMute" = "exec ${wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";

            "XF86AudioPlay" = "exec ${playerctl}/bin/playerctl play-pause --player=%any,mpv";
            "XF86AudioPrev" = "exec ${playerctl}/bin/playerctl previous --player=%any,mpv";
            "XF86AudioNext" = "exec ${playerctl}/bin/playerctl next --player=%any,mpv";
            "XF86AudioStop" = "exec ${playerctl}/bin/playerctl play-pause --player=%any,mpv";

            "XF86MonBrightnessUp" = "exec ${brightnessctl}/bin/brightnessctl set +5%";
            "XF86MonBrightnessDown" = "exec ${brightnessctl}/bin/brightnessctl set 5%-";
          };
          colors = {
            background = window_bg_color;
            focused = {
              border = accent_bg_color;
              background = accent_bg_color;
              text = accent_fg_color;
              indicator = accent_bg_color;
              childBorder = accent_bg_color;
            };
            focusedInactive = {
              border = view_bg_color;
              background = view_bg_color;
              text = view_fg_color;
              indicator = view_bg_color;
              childBorder = view_bg_color;
            };
            unfocused = {
              border = view_bg_color;
              background = view_bg_color;
              text = view_fg_color;
              indicator = view_bg_color;
              childBorder = view_bg_color;
            };
            urgent = {
              border = urgent_bg_color;
              background = urgent_bg_color;
              text = urgent_fg_color;
              indicator = urgent_bg_color;
              childBorder = urgent_bg_color;
            };
            placeholder = {
              border = accent_bg_color;
              background = accent_bg_color;
              text = accent_fg_color;
              indicator = accent_bg_color;
              childBorder = accent_bg_color;
            };
          };
          modes = {
            audio = {
              # [i] input, [o] output
              Escape = "mode default";
              Return = "mode default";
              "i" = "exec ${rofi-pulse-select}/bin/rofi-pulse-select source, mode default";
              "o" = "exec ${rofi-pulse-select}/bin/rofi-pulse-select sink, mode default";
            };
            printscreen = {
              # [1] screen, [2] region, [3] window
              Escape = "mode default";
              Return = "mode default";
              "1" = "exec ${shotman}/bin/shotman -c output, mode default";
              "2" = "exec ${shotman}/bin/shotman -c region, mode default";
              "3" = "exec ${shotman}/bin/shotman -c window, mode default";
            };
            record = {
              # [1] all+audio, [2] region+audio, [3] all, [4] region, [0] stop
              Escape = "mode default";
              Return = "mode default";
              "1" = ''exec ${recorder} ${opt} --filename="${vfilename}" --audio , mode default'';
              "2" =
                ''exec ${recorder} ${opt} --filename="${vfilename}" --geometry "$(${slurp}/bin/slurp -d)" --audio , mode default'';
              "3" = ''exec ${recorder} ${opt} --filename="${vfilename}" , mode default'';
              "4" =
                ''exec ${recorder} ${opt} --filename="${vfilename}" --geometry "$(${slurp}/bin/slurp -d)" , mode default'';
              "0" = "exec ${procps}/bin/pkill --signal INT ${screenrec}, mode default";
            };
            resize = {
              Escape = "mode default";
              Return = "mode default";
              "${down}" = "resize grow height 5 px or 5 ppt";
              "${left}" = "resize shrink width 5 px or 5 ppt";
              "${right}" = "resize grow width 5 px or 5 ppt";
              "${up}" = "resize shrink height 5 px or 5 ppt";
            };
          };
        };
      };
    };
  };
}
