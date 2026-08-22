# The full desktop, which is what a NixOS host gets. Machines that only want
# the CLI half import ./common.nix alone — see homeConfigurations in flake.nix.
{ ... }:
{
  imports = [
    ./common.nix
    ./desktop.nix

    # Services the host desktop would otherwise provide. A NixOS host has no
    # one else to do it; the work laptop gets both from GNOME, and udiskie in
    # particular cannot be moved off graphical-session.target, which GNOME
    # reaches too.
    ./services/gnome-keyring.nix
    ./services/udiskie.nix

    # XDG user dirs and mime associations are session-wide, not sway's. On the
    # work laptop they would repoint GNOME's folders at empty ones and send its
    # PDFs to zathura, so that profile keeps the distro's.
    ./xdg
  ];
}
