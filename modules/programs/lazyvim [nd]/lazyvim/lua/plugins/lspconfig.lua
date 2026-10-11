return {
  "neovim/nvim-lspconfig",
  opts = function(_, opts)
    opts.inlay_hints.enabled = false
    if vim.fn.has("mac") == 1 then
      opts.servers.kotlin_language_server = { enabled = false }
      opts.servers.kotlin_lsp = { cmd = { "kotlin-lsp", "--stdio" } }
    end
  end,
  init = function()
    -- jarClassContents is specific to the old kotlin-language-server.
    if vim.fn.has("mac") == 0 then
      require("config.kotlin_lsp").setup()
    end
  end,
}
