# The systemd half of the terminal layer: everything here assumes a Linux
# user session and would not evaluate on macOS.
{ ... }:
{
  imports = [
    ./services/common.nix
  ];

  # Restart the user services whose unit changed, instead of only warning about it.
  systemd.user.startServices = "sd-switch";
}
