return {
  "neovim/nvim-lspconfig",
  opts = {
    inlay_hints = { enabled = false },
  },
  init = function()
    require("config.kotlin_lsp").setup()
  end,
}
