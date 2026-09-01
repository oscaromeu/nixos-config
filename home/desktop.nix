# Sway and the graphical apps. Expects the system to provide seat, audio,
# portals and GPU drivers — on NixOS that is ./nixos, elsewhere the distro.
{ ... }:
{
  imports = [
    ./config/qt
    ./fonts
    ./packages/desktop.nix
    ./programs/desktop.nix
    ./services/desktop.nix
    ./themes
    ./wayland
  ];

  # Every wayland user service hangs off sway's own target rather than the
  # generic graphical-session one, which GNOME also reaches. Read by 35 of the
  # home-manager modules, cliphist and wpaperd among them.
  wayland.systemd.target = "sway-session.target";

  # Exported by sway's own wrapper rather than by home.sessionVariables: those
  # reach every login, so on a machine that also runs GNOME they would tell its
  # portals they are on sway.
  wayland.windowManager.sway.extraSessionCommands = ''
    export XDG_CURRENT_DESKTOP=sway
    export XDG_SESSION_DESKTOP=sway
    export XDG_SESSION_TYPE=wayland

    # Native Wayland for the apps that need telling
    export MOZ_ENABLE_WAYLAND=1
    export MOZ_USE_XINPUT2=1
    export NIXOS_OZONE_WL=1 # electron/chromium
    export QT_QPA_PLATFORM=wayland
    export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
    export SDL_VIDEODRIVER=wayland

    export GTK_THEME=Breeze-Dark

    # Java: avoids grey windows on tiling WMs
    export _JAVA_AWT_WM_NONREPARENTING=1

    # never, not prefer: with DISPLAY set by Xwayland ssh would route the
    # unknown-host-key prompt to an askpass binary no profile installs, so
    # every first connection died with "Host key verification failed".
    export SSH_ASKPASS_REQUIRE=never
  '';
}
