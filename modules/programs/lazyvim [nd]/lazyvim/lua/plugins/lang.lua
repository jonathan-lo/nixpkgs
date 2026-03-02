return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        yamlls = {
          settings = {
            yaml = {
              format = {
                enable = false,
              },
            },
          },
        },
        terraformls = {
          root_dir = function(fname)
            -- Only activate terraform-ls for files inside directories named "infrastructure" or "terraform"
            local path = vim.fn.fnamemodify(fname, ":p")
            if not (path:match("/infrastructure/") or path:match("/terraform/")) then
              return nil
            end
            local util = require("lspconfig.util")
            return util.root_pattern(".terraform", "*.tf")(fname)
          end,
        },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        kotlin = {}, -- disable ktlint formatting
      },
    },
  },
}
