return {
  "mfussenegger/nvim-lint",
  optional = true,
  opts = {
    linters = {
      -- https://github.com/LazyVim/LazyVim/discussions/2268
      -- markdownlint-cli2 has no --disable flag, so rules are turned off via a base
      -- config file rather than args.
      ["markdownlint-cli2"] = {
        args = { "--config", vim.fn.stdpath("config") .. "/.markdownlint-cli2.jsonc", "-" },
      },
      -- golangci-lint takes a global lock in $TMPDIR, so an in-editor lint makes
      -- concurrent CLI runs (e.g. an agent's `golangci-lint run`) exit with
      -- "parallel golangci-lint is running". Skip the lock for editor runs only.
      -- LazyVim appends prepend_args after the linted path, which cobra accepts.
      golangcilint = {
        prepend_args = { "--allow-parallel-runners" },
      },
    },
  },
}
