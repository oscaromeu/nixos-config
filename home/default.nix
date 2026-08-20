{ profile, alias, ... }:
{
  imports = [
    ./config
    ./fonts
    ./packages
    ./programs
    ./services
    ./themes
    ./wayland
    ./xdg
  ];

  home = {
    username = profile.name;
    homeDirectory = "/home/${profile.name}";

    # Same rule as system.stateVersion: set once, never changed.
    stateVersion = "26.05";

    shellAliases = alias.abbr;

    sessionVariables = {
      XDG_CURRENT_DESKTOP = "sway";
      XDG_SESSION_DESKTOP = "sway";
      XDG_SESSION_TYPE = "wayland";

      # Native Wayland for the apps that need telling
      MOZ_ENABLE_WAYLAND = "1";
      MOZ_USE_XINPUT2 = "1";
      NIXOS_OZONE_WL = "1"; # electron/chromium
      QT_QPA_PLATFORM = "wayland";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      SDL_VIDEODRIVER = "wayland";

      GTK_THEME = "Breeze-Dark";

      # Java: avoids grey windows on tiling WMs
      _JAVA_AWT_WM_NONREPARENTING = 1;

      SSH_ASKPASS_REQUIRE = "prefer";
    };
  };
}
