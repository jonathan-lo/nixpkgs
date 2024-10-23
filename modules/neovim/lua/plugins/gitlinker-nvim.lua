require('gitlinker').setup {
  opts = {
    action_callback = function(url)
      -- yank to unnamed register
      vim.api.nvim_command('let @" = \'' .. url .. '\'')
      -- copy to the system clipboard using OSC52
      require('osc52').copy(url)
    end,
  },
  mappings = "<leader>gy"
}
