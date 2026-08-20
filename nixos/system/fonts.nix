# Default families come from config/theme.nix.
{ pkgs, theme, ... }:
{
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      fira
      fira-code
      fira-mono
      fira-sans
      font-awesome
      jetbrains-mono
      nerd-fonts.fira-code
      nerd-fonts.fira-mono
      nerd-fonts.hack
      nerd-fonts.symbols-only
      nerd-fonts.ubuntu-mono
      ubuntu-classic
      roboto
      roboto-mono
      source-code-pro
      source-sans
      source-sans-pro
      source-serif
      source-serif-pro
      twitter-color-emoji
    ];
    fontconfig = {
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
