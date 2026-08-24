-- Native nvim 0.11 LSP API; nvim-lspconfig only provides the server definitions.
-- The binaries come from extraPackages in default.nix.

-- Diagnostics: nerd font icons in the gutter, sorted by severity
vim.diagnostic.config({
  severity_sort = true,
  virtual_text = { source = 'if_many' },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = ' ',
      [vim.diagnostic.severity.WARN] = ' ',
      [vim.diagnostic.severity.INFO] = ' ',
      [vim.diagnostic.severity.HINT] = ' ',
    },
  },
})

-- Every server advertises blink.cmp completion capabilities
vim.lsp.config('*', {
  capabilities = require('blink.cmp').get_lsp_capabilities(),
})

-- lua_ls: teach it the `vim` global
vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      diagnostics = { globals = { 'vim' } },
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
})

-- Schemas from SchemaStore: kubernetes manifests, taskfiles, github actions...
vim.lsp.config('yamlls', {
  settings = {
    yaml = {
      schemaStore = { enable = false, url = '' },
      schemas = require('schemastore').yaml.schemas(),
    },
  },
})

vim.lsp.enable({ 'gopls', 'nixd', 'lua_ls', 'yamlls', 'marksman' })

-- Maps that only make sense with an LSP attached
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local tb = require('telescope.builtin')
    local function map(keys, fn, desc)
      vim.keymap.set('n', keys, fn, { buffer = ev.buf, desc = desc })
    end
    map('gd', tb.lsp_definitions, 'Go to definition')
    map('gr', tb.lsp_references, 'References')
    map('gI', tb.lsp_implementations, 'Implementations')
    map('<leader>cs', tb.lsp_document_symbols, 'Document symbols')
    map('<leader>cr', vim.lsp.buf.rename, 'Rename symbol')
    map('<leader>ca', vim.lsp.buf.code_action, 'Code action')
  end,
})
