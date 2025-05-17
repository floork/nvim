-- Set completion options
vim.o.completeopt = "menu,menuone,noselect,noinsert,popup,fuzzy"

-- Autocompletion on LSP attach
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("configs-lsp-attach", { clear = true }),
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

    -- Set trigger characters for autocompletion
    -- Note: This will only work if the server supports the dynamic registration
    -- of trigger characters or if the trigger characters are initially empty.
    -- Some servers might not allow overriding this after initialization.
    if client.server_capabilities.completionProvider then
      client.server_capabilities.completionProvider.triggerCharacters =
        vim.split("qwertyuiopasdfghjklzxcvbnm.", "")
    end

    -- Check if the client supports the textDocument/completion method
    if not client:supports_method("textDocument/completion") then
      -- If the client does not support completion, show a notification
      vim.notify(
        "LSP server for " .. client.name .. " does not support textDocument/completion.",
        vim.log.levels.INFO
      )
    end

    vim.lsp.completion.enable(true, client.id, args.buf, {
      autotrigger = true,
    })

    -- Resolve completion item documentation on selection change
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
            if not item then return end
            local docs = (item.documentation or {}).value
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
  end,
})
