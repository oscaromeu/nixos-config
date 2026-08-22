# On NixOS the generic families are declared by nixos/system/fonts.nix. A
# standalone profile has no system layer, so without this the host distro picks
# them and the two machines render in different fonts.
{ theme, ... }:
{
  fonts = {
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [
          "${theme.font-mono}"
          "${theme.font-mono-alt}"
        ];
        serif = [
          "${theme.font-serif}"
          "${theme.font-serif-alt}"
        ];
        sansSerif = [
          "${theme.font}"
          "${theme.font-alt}"
        ];
        emoji = [ "${theme.font-emoji}" ];
      };
    };
  };
}
