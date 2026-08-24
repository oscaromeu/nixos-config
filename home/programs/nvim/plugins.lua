-- Nix already installs the plugins (see default.nix); here they are only tuned.

-- Treesitter main branch (the one in nixpkgs 26.05) enables per buffer. Grammars come
-- from nix, and the pcall keeps filetypes without a parser quiet.
vim.api.nvim_create_autocmd('FileType', {
  callback = function(ev)
    if pcall(vim.treesitter.start, ev.buf) then
      vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})

local telescope = require('telescope')
telescope.setup({
  defaults = {
    prompt_prefix = '   ',
    sorting_strategy = 'ascending',
    layout_config = { horizontal = { prompt_position = 'top' } },
  },
})
telescope.load_extension('fzf')

-- Statusline; the "base16" theme reads the active colorscheme
require('lualine').setup({
  options = {
    theme = 'base16',
    globalstatus = true,
    section_separators = '',
    component_separators = '│',
  },
})

-- Git signs; the maps only exist in buffers under git
require('gitsigns').setup({
  on_attach = function(bufnr)
    local gs = require('gitsigns')
    local function map(mode, l, r, desc)
      vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
    end
    map('n', ']h', function() gs.nav_hunk('next') end, 'Next hunk')
    map('n', '[h', function() gs.nav_hunk('prev') end, 'Previous hunk')
    map('n', '<leader>gp', gs.preview_hunk, 'Preview hunk')
    map('n', '<leader>gs', gs.stage_hunk, 'Stage hunk')
    map('n', '<leader>gr', gs.reset_hunk, 'Reset hunk')
    map('n', '<leader>gb', function() gs.blame_line({ full = true }) end, 'Blame line')
  end,
})

-- Oil: directory as an editable buffer (dd deletes, p pastes)
require('oil').setup({
  default_file_explorer = true,
  view_options = { show_hidden = true },
})

-- Completion: <C-n>/<C-p> move, <C-y> accepts, <C-space> opens docs
require('blink.cmp').setup({
  keymap = { preset = 'default' },
  appearance = { nerd_font_variant = 'mono' },
  completion = {
    documentation = { auto_show = true, auto_show_delay_ms = 200 },
  },
  signature = { enabled = true },
})

-- Format on save, falling back to the LSP when there is no dedicated formatter
require('conform').setup({
  formatters_by_ft = {
    go = { 'goimports', 'gofmt' },
    lua = { 'stylua' },
    nix = { 'nixfmt' },
  },
  format_on_save = { timeout_ms = 1000, lsp_format = 'fallback' },
})

require('ibl').setup({
  indent = { char = '│' },
  scope = { enabled = false },
})

require('nvim-autopairs').setup({})

-- TODO/FIXME/HACK highlighting (:TodoTelescope lists them)
require('todo-comments').setup({})

-- Keymap cheatsheet on <leader>
require('which-key').setup({
  spec = {
    { '<leader>f', group = 'Find' },
    { '<leader>g', group = 'Git' },
    { '<leader>c', group = 'Code' },
  },
})

-- search and replace across the project
require('grug-far').setup({})
