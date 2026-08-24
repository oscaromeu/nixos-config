-- General maps. The LSP ones are in lsp.lua and the git ones in plugins.lua.
local map = vim.keymap.set

-- Esc also clears the search highlight
map('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Move between windows without <C-w>
map('n', '<C-h>', '<C-w>h', { desc = 'Window left' })
map('n', '<C-j>', '<C-w>j', { desc = 'Window down' })
map('n', '<C-k>', '<C-w>k', { desc = 'Window up' })
map('n', '<C-l>', '<C-w>l', { desc = 'Window right' })

-- Keep the cursor centred on half-page jumps
map('n', '<C-d>', '<C-d>zz')
map('n', '<C-u>', '<C-u>zz')

-- Reindent without losing the selection
map('v', '<', '<gv')
map('v', '>', '>gv')

-- Parent directory as an editable buffer (oil)
map('n', '-', '<cmd>Oil<CR>', { desc = 'Browse directory' })

-- Telescope
local tb = require('telescope.builtin')
map('n', '<leader>ff', tb.find_files, { desc = 'Files' })
map('n', '<leader>fg', tb.live_grep, { desc = 'Grep the project' })
map('n', '<leader>fb', tb.buffers, { desc = 'Buffers' })
map('n', '<leader>fr', tb.oldfiles, { desc = 'Recent' })
map('n', '<leader>fh', tb.help_tags, { desc = 'Help' })
map('n', '<leader>fs', '<cmd>GrugFar<cr>', { desc = 'Search & replace' })
map('n', '<leader>cd', '<cmd>SopsDecrypt<cr>', { desc = 'Sops decrypt' })
map('n', '<leader>ce', '<cmd>SopsEncrypt<cr>', { desc = 'Sops encrypt' })
map('n', '<leader>cx', '<cmd>Trouble diagnostics toggle<cr>', { desc = 'Problems' })
map('n', '<leader>gd', '<cmd>DiffviewOpen<cr>', { desc = 'Diff view' })
map('n', '<leader>fd', tb.diagnostics, { desc = 'Diagnostics' })
map('n', '<leader>/', tb.current_buffer_fuzzy_find, { desc = 'Search the buffer' })

-- Diagnostics
map('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Diagnostic detail' })

-- Format by hand; format-on-save is in plugins.lua
map('n', '<leader>cf', function()
  require('conform').format({ async = true })
end, { desc = 'Format' })
