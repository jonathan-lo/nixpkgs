return {
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<C-h>", "<cmd>TmuxNavigateLeft<cr>",  desc = "Navigate window/pane left" },
      { "<C-j>", "<cmd>TmuxNavigateDown<cr>",  desc = "Navigate window/pane down" },
      { "<C-k>", "<cmd>TmuxNavigateUp<cr>",    desc = "Navigate window/pane up" },
      { "<C-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Navigate window/pane right" },
    },
  },
}
