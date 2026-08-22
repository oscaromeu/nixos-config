{ ... }:
let

  theme = "Breeze-Dark";
  icon = "Papirus-Dark";
  cursor = "breeze_cursors";
  cursor-size = 24;
  font = "Ubuntu";
  font-alt = "Fira Sans";
  # Nerd Font variant: the fish prompt needs the extra glyphs.
  font-mono = "UbuntuMono Nerd Font";
  font-mono-alt = "Fira Mono";
  font-serif = "Fira Serif";
  font-serif-alt = "Source Serif Pro";
  # font-awesome v7 moved the classic codepoints and left blank icons; this keeps them.
  font-symbol = "Symbols Nerd Font";
  font-emoji = "Twitter Color Emoji";
  font-size = 10;
  font-size-alt = 14;
  # The bar is its own case: it has to match the size the apps render at.
  font-size-bar = 16;
  # Terminals only, so bumping them leaves rofi, mako and the titlebars alone.
  font-size-term = 16;

in
{

  inherit theme;
  inherit icon;
  inherit cursor;
  inherit cursor-size;
  inherit font;
  inherit font-alt;
  inherit font-mono;
  inherit font-mono-alt;
  inherit font-serif;
  inherit font-serif-alt;
  inherit font-symbol;
  inherit font-emoji;
  inherit font-size;
  inherit font-size-alt;
  inherit font-size-bar;
  inherit font-size-term;
}
