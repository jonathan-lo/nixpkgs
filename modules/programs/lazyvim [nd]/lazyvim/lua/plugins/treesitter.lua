return {
  {
    "nvim-treesitter/nvim-treesitter",
    commit = "42fc28ba918343ebfd5565147a42a26580579482", -- pinned to pre-breaking change; nix-managed parsers assume old API
    config = function()
      -- old API: opts aren't applied automatically by LazyVim for this pinned version
      require("nvim-treesitter.configs").setup({
        highlight = { enable = true },
      })
    end,
  },
}
