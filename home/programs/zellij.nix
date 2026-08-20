# Not auto-started: run `zellij` when I want it.
{
  color,
  pkgs,
  ...
}:
with pkgs;
{
  programs = {
    zellij = {
      enable = true;
      enableFishIntegration = false;
      settings = {
        copy_command = "${wl-clipboard}/bin/wl-copy";
        default_shell = "fish";
        pane_frames = false;
        simplified_ui = true;
        show_startup_tips = false;
        show_release_notes = false;
        theme = "swayhome";
        themes = {
          swayhome = {
            fg = color.h_foreground;
            bg = color.h_black;
            black = color.h_black;
            red = color.h_red;
            green = color.h_green;
            yellow = color.h_yellow;
            blue = color.h_blue;
            magenta = color.h_purple;
            cyan = color.h_cyan;
            white = color.h_white;
            orange = color.h_yellow;
          };
        };
      };
    };
  };
}
