-- base16 built from the Breeze Dark palette nix injects (_G.breeze, see default.nix).
local c = _G.breeze

require('base16-colorscheme').setup({
  base00 = c.background, -- background
  base01 = c.background_alt, -- alternate background (popups, statusline)
  base02 = c.bright_black, -- visual selection
  base03 = c.foreground_muted, -- comments
  base04 = c.foreground_muted, -- line numbers
  base05 = c.foreground, -- text
  base06 = c.bright_white,
  base07 = c.bright_white,
  base08 = c.red, -- variables
  base09 = c.yellow, -- numbers and constants (the Breeze "yellow" is orange)
  base0A = c.bright_yellow, -- types and classes
  base0B = c.green, -- strings
  base0C = c.cyan, -- regexp and escapes
  base0D = c.blue, -- functions
  base0E = c.purple, -- keywords
  base0F = c.bright_red, -- deprecated / embedded punctuation
})

-- Floats: alternate background, quiet border
vim.api.nvim_set_hl(0, 'NormalFloat', { bg = c.background_alt })
vim.api.nvim_set_hl(0, 'FloatBorder', { bg = c.background_alt, fg = c.bright_black })
