# Kept from swayhome (abbr h); the default editor is nvim.
{ ... }:
{
  programs = {
    helix = {
      enable = true;
      settings = {
        theme = "base16_transparent";
        editor = {
          bufferline = "always";
          cursorline = true;
          line-number = "relative";
          indent-guides = {
            render = true;
          };
          lsp = {
            display-messages = true;
          };
        };
      };
    };
  };
}
