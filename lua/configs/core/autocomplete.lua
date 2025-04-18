-- Set completion options
vim.o.completeopt = "menu,menuone,noselect,noinsert,popup"

-- Define mappings for the popup menu navigation
local pumMaps = {
  ['<Tab>']   = '<C-n>',
  ['<S-Tab>'] = '<C-p>',
  ['<Down>']  = '<C-n>',
  ['<Up>']    = '<C-p>',
  ['<CR>']    = '<C-y>',
}

for insertKmap, pumKmap in pairs(pumMaps) do
  vim.keymap.set('i', insertKmap, function()
    return vim.fn.pumvisible() == 1 and pumKmap or insertKmap
  end, { expr = true })
end

-- Autocompletion on LSP attach
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("configs-lsp-attach", { clear = true }),
  callback = function(args)
    local client =
        assert(vim.lsp.get_client_by_id(args.data.client_id))

    -- Set trigger characters for autocompletion
    client.server_capabilities.completionProvider.triggerCharacters =
        vim.split("qwertyuiopasdfghjklzxcvbnm. ", "")

    -- Listen to insert mode text changes and fetch completions.
    vim.api.nvim_create_autocmd({ "TextChangedI" }, {
      buffer = args.buf,
      callback = function()
        vim.lsp.completion.get()
      end,
    })

    vim.lsp.completion.enable(true, client.id, args.buf, {
      autotrigger = true,
    })

    if client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, args.buf, {
        autotrigger = true,
      })
    end

    -- Resolve completion item documentation on selection change
    local _, cancel_prev = nil, function() end
    vim.api.nvim_create_autocmd("CompleteChanged", {
      buffer = args.buf,
      callback = function()
        cancel_prev()
        local info = vim.fn.complete_info({ "selected" })
        local completionItem =
            vim.tbl_get(vim.v.completed_item, "user_data", "nvim", "lsp", "completion_item")
        if completionItem == nil then
          return
        end
        _, cancel_prev =
            vim.lsp.buf_request(args.buf,
              vim.lsp.protocol.Methods.completionItem_resolve,
              completionItem,
              function(err, item, ctx)
                if not item then
                  return
                end
                local docs = (item.documentation or {}).value
                local win = vim.api.nvim__complete_set(info["selected"], {
                  info = docs,
                })
                if win.winid and vim.api.nvim_win_is_valid(win.winid) then
                  vim.treesitter.start(win.bufnr, "markdown")
                  vim.wo[win.winid].conceallevel = 3
                end
              end)
      end,
    })
  end,
})
