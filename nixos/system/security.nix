{ ... }:
{
  security = {
    rtkit.enable = true; # realtime priority for pipewire
    polkit.enable = true;

    # Without this swaylock cannot validate the password and never unlocks.
    pam = {
      services = {
        swaylock = { };
      };
    };
  };
}
