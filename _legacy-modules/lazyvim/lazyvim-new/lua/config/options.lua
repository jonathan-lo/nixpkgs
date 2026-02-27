-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Nix-managed treesitter parsers
local parsers_path = vim.env.NVIM_TREESITTER_PARSERS
if parsers_path then
  vim.opt.runtimepath:prepend(parsers_path)
end

-- Disable auto-format on save
vim.g.autoformat = false
