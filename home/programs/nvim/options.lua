-- Leader goes first: plugins build their maps with whatever it is at that moment.
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Unused providers: silences the :checkhealth warnings
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0

local o = vim.o

-- Relative line numbers
o.number = true
o.relativenumber = true
o.cursorline = true
o.signcolumn = 'yes' -- always visible, so the text does not jump around
o.termguicolors = true

o.scrolloff = 8
o.wrap = false
o.breakindent = true

-- 2 spaces by default; go and make use tabs via ftplugin
o.expandtab = true
o.shiftwidth = 2
o.tabstop = 2

-- Case-insensitive search unless I type a capital
o.ignorecase = true
o.smartcase = true
o.inccommand = 'split' -- preview :s/../../ in a split

o.splitright = true
o.splitbelow = true
o.winborder = 'rounded'
o.laststatus = 3 -- one global statusline, not one per window

-- Undo persists across sessions
o.undofile = true

-- System clipboard (wl-clipboard is in home/packages)
o.clipboard = 'unnamedplus'

o.updatetime = 250
o.timeoutlen = 500

o.list = true
o.listchars = 'tab:» ,trail:·,nbsp:␣'

-- Briefly highlight what was yanked
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.hl.on_yank()
  end,
})
