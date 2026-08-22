# On NixOS these come from nixos/system/fonts.nix. A standalone profile has no
# system layer, and Ubuntu ships no Nerd Font at all, which leaves waybar's
# icons blank — so the families config/theme.nix names are installed here too.
# Same store paths as the system ones, so a NixOS host pays nothing for them.
{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      fira # font-alt, font-mono-alt, font-serif-alt
      nerd-fonts.symbols-only # font-symbol
      nerd-fonts.ubuntu-mono # font-mono
      twitter-color-emoji # font-emoji
      ubuntu-classic # font
    ];
  };
}
