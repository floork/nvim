-- Set completion options
vim.o.completeopt = "menu,menuone,noselect,noinsert,popup,fuzzy"

-- Autocompletion on LSP attach
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("configs-lsp-attach", { clear = true }),
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

    -- Set trigger characters for autocompletion
    if client.server_capabilities.completionProvider then
      client.server_capabilities.completionProvider.triggerCharacters =
        vim.split("qwertyuiopasdfghjklzxcvbnm.", "")
    end

    -- Check if the client supports the textDocument/completion method
    if not client:supports_method("textDocument/completion") then
      vim.notify(
        "LSP server for " .. client.name .. " does not support textDocument/completion.",
        vim.log.levels.INFO
      )
    end

    vim.lsp.completion.enable(true, client.id, args.buf, {
      autotrigger = true,
    })

    -- Only set up completion item resolution if the server supports it
    if client:supports_method("completionItem/resolve") then
      local _, cancel_prev = nil, function() end
      vim.api.nvim_create_autocmd("CompleteChanged", {
        buffer = args.buf,
        callback = function()
          cancel_prev()
          local info = vim.fn.complete_info({ "selected" })
          local completionItem =
            vim.tbl_get(vim.v.completed_item, "user_data", "nvim", "lsp", "completion_item")
          if completionItem == nil then return end

          _, cancel_prev = vim.lsp.buf_request(
            args.buf,
            vim.lsp.protocol.Methods.completionItem_resolve,
            completionItem,
            function(err, item, ctx)
              if err or not item then return end
              local docs = (item.documentation or {}).value
              if not docs then return end
              local win = vim.api.nvim__complete_set(info["selected"], {
                info = docs,
              })
              if win.winid and vim.api.nvim_win_is_valid(win.winid) then
                vim.treesitter.start(win.bufnr, "markdown")
                vim.wo[win.winid].conceallevel = 3
              end
            end
          )
        end,
      })
    else
      vim.notify(
        "LSP server for "
          .. client.name
          .. " does not support completionItem/resolve. "
          .. "Documentation preview will not be available.",
        vim.log.levels.DEBUG
      )
    end
  end,
})
