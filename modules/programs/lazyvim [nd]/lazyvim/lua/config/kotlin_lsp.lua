-- Kotlin LSP decompiler for jar: and jrt: sources
local M = {}

function M.setup()
  local group = vim.api.nvim_create_augroup("KotlinLspDecompile", { clear = true })

  vim.api.nvim_create_autocmd("BufReadCmd", {
    group = group,
    pattern = { "jar:/*", "jrt:/*" },
    callback = function(args)
      local uri = args.match
      local bufnr = args.buf

      -- Find an active Kotlin LSP client
      local clients = vim.lsp.get_clients({ name = "kotlin_language_server" })
      if #clients == 0 then
        vim.notify("Kotlin LSP not running", vim.log.levels.WARN)
        return
      end

      local client = clients[1]

      -- Request decompiled source from Kotlin LSP
      client.request("kotlin/jarClassContents", { uri = uri }, function(err, result)
        if err then
          vim.notify("Decompile error: " .. tostring(err), vim.log.levels.ERROR)
          return
        end

        if result and result.contents then
          local lines = vim.split(result.contents, "\n", { plain = true })
          vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
          vim.bo[bufnr].filetype = "kotlin"
          vim.bo[bufnr].modifiable = false
          vim.bo[bufnr].readonly = true
          vim.bo[bufnr].buftype = "nofile"
        end
      end, bufnr)
    end,
  })
end

return M
