# Nix installs the plugins and the tools; the config lives in the .lua files here,
# concatenated in order into a single init.lua.
{
  pkgs,
  lib,
  color,
  ...
}:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    # Binaries nvim expects on PATH.
    extraPackages = with pkgs; [
      # LSPs
      gopls
      nixd
      lua-language-server
      yaml-language-server
      marksman # markdown

      # formatters (conform.nvim)
      gotools # goimports
      nixfmt
      stylua
    ];

    plugins = with pkgs.vimPlugins; [
      # Grammars come precompiled from nix, so no :TSInstall per language
      nvim-treesitter.withAllGrammars

      # base16 theme; colorscheme.lua feeds it the Breeze palette
      base16-nvim

      # the rest of what vscode was still doing here
      SchemaStore-nvim # json/yaml schemas for the LSP
      diffview-nvim # review diffs properly
      nvim-sops # decrypt and re-encrypt secrets in the buffer
      nvim-surround
      render-markdown-nvim
      trouble-nvim # the Problems panel
      vim-sleuth # guess the file's indentation

      # search and replace across the project, vscode style
      grug-far-nvim

      # fuzzy finder
      plenary-nvim
      telescope-nvim
      telescope-fzf-native-nvim

      # LSP and completion
      nvim-lspconfig
      blink-cmp
      friendly-snippets

      # format on save
      conform-nvim

      # git signs in the gutter
      gitsigns-nvim

      # directory as an editable buffer
      oil-nvim

      # UI
      lualine-nvim
      nvim-web-devicons
      which-key-nvim
      indent-blankline-nvim
      todo-comments-nvim
      nvim-autopairs
    ];

    # Palette first, then each .lua in this order.
    initLua =
      ''
        -- Breeze Dark palette injected from config/color.nix — do not edit here
        _G.breeze = {
          background = "${color.h_background}",
          background_alt = "${color.h_background_alt}",
          foreground = "${color.h_foreground}",
          foreground_muted = "${color.h_foreground_muted}",
          black = "${color.h_black}",
          red = "${color.h_red}",
          green = "${color.h_green}",
          yellow = "${color.h_yellow}",
          blue = "${color.h_blue}",
          purple = "${color.h_purple}",
          cyan = "${color.h_cyan}",
          white = "${color.h_white}",
          bright_black = "${color.h_bright_black}",
          bright_red = "${color.h_bright_red}",
          bright_green = "${color.h_bright_green}",
          bright_yellow = "${color.h_bright_yellow}",
          bright_blue = "${color.h_bright_blue}",
          bright_purple = "${color.h_bright_purple}",
          bright_cyan = "${color.h_bright_cyan}",
          bright_white = "${color.h_bright_white}",
        }
      ''
      + lib.concatMapStringsSep "\n" lib.fileContents [
        ./options.lua
        ./colorscheme.lua
        ./plugins.lua
        ./lsp.lua
        ./keymaps.lua
      ];
  };
}
