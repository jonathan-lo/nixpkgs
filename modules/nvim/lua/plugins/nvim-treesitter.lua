require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
  },
}

-- Use HCL parser for terraform files as there isn't a standalone terraform parser.
vim.treesitter.language.register('hcl', {'terraform', 'terraform-vars'})
