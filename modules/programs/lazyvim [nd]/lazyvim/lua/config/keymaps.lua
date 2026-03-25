-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- LSP goto definition with Ctrl-] (classic vim tag jump)
vim.keymap.set("n", "<C-]>", vim.lsp.buf.definition, { desc = "Goto Definition" })

-- CodeSnap
vim.keymap.set("v", "<leader>cy", "<cmd>CodeSnap<cr>", { desc = "CodeSnap" })
