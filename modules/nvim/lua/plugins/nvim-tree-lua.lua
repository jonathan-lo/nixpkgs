local api = require("nvim-tree.api")
require("nvim-tree").setup()
vim.keymap.set('n', '<A-1>', api.tree.toggle, opts)
