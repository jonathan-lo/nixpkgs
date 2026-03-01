-- Derive JAVA_HOME from java on PATH to keep JDTLS on 21+ runtime
local java_exe = vim.fn.exepath("java")
if java_exe ~= "" then
  local java_home = vim.fn.fnamemodify(java_exe, ":h:h")
  vim.env.JAVA_HOME = java_home
  vim.env.PATH = java_home .. "/bin:" .. vim.env.PATH
end

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
