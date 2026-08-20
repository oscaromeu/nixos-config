{ profile, ... }:
{
  i18n = {
    defaultLocale = "${profile.locale}";
    extraLocaleSettings = {
      LC_ADDRESS = "${profile.locale}";
      LC_IDENTIFICATION = "${profile.locale}";
      LC_MEASUREMENT = "${profile.locale}";
      LC_MONETARY = "${profile.locale}";
      LC_NAME = "${profile.locale}";
      LC_NUMERIC = "${profile.locale}";
      LC_PAPER = "${profile.locale}";
      LC_TELEPHONE = "${profile.locale}";
      LC_TIME = "${profile.locale}";
    };
  };

  # TTY keyboard; sway sets its own in home/wayland/sway.nix.
  console = {
    keyMap = "${profile.layout}";
  };
}
