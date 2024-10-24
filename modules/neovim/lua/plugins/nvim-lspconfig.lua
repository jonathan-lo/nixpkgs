local cmp_caps = require'cmp_nvim_lsp'.default_capabilities()

require'lspconfig'.gopls.setup{
  capabilities = cmp_caps,
  settings = {
    gopls = {
      gofumpt = true,
      staticcheck = true,
    },
  },
}

require'lspconfig'.rnix.setup{
  capabilities = cmp_caps,
}

require'lspconfig'.yamlls.setup{
  capabilities = cmp_caps,
  settings = {
    yaml = {
      schemas = {
        kubernetes = "/*",
      },
    },
  },
}

require'lspconfig'.helm_ls.setup{
  settings = {
    ["helm-ls"] = {
      yamlls = {
        path = "yaml-language-server",
      },
    },
  },
}

local opts = {buffer=bufnr, noremap=true, silent=true}
vim.keymap.set('n', '<C-]>', vim.lsp.buf.definition, opts)
vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, opts)
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
