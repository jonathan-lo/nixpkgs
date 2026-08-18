-- https://github.com/LazyVim/LazyVim/discussions/2268
-- markdownlint-cli2 has no --disable flag, so rules are turned off via a base
-- config file rather than args.
return {
  "mfussenegger/nvim-lint",
  optional = true,
  opts = {
    linters = {
      ["markdownlint-cli2"] = {
        args = { "--config", vim.fn.stdpath("config") .. "/.markdownlint-cli2.jsonc", "-" },
      },
    },
  },
}
