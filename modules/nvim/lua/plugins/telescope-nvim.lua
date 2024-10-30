return {

{
  "nvim-telescope/telescope.nvim",
  dependencies = {
    {
      "nvim-telescope/telescope-fzf-native.nvim"
    },
  },
  keys = {
    { "rg", "<cmd>Telescope live_grep<cr>", desc = "Grep (Root Dir)" },
    { "<C-n>", "<cmd>Telescope find_files<cr>", desc = "Find files (Root Dir)" }
  }
}
}
