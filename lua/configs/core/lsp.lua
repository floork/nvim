vim.o.completeopt = "menu,menuone,noselect,noinsert,popup"

local pumMaps = {
  ['<Tab>'] = '<C-n>',
  ['<S-Tab>'] = '<C-p>',
  ['<Down>'] = '<C-n>',
  ['<Up>'] = '<C-p>',
  ['<CR>'] = '<C-y>',
}
for insertKmap, pumKmap in pairs(pumMaps) do
  vim.keymap.set('i', insertKmap, function()
    return vim.fn.pumvisible() == 1 and pumKmap or insertKmap
  end, { expr = true })
end

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("configs-lsp-attach", { clear = true }),
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    client.server_capabilities.completionProvider.triggerCharacters = vim.split("qwertyuiopasdfghjklzxcvbnm. ", "")
    vim.api.nvim_create_autocmd({ 'TextChangedI' }, {
      buffer = args.buf,
      callback = function()
        vim.lsp.completion.get()
      end
    })
    vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })

    if client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
    end

    local _, cancel_prev = nil, function() end
    vim.api.nvim_create_autocmd('CompleteChanged', {
      buffer = args.buf,
      callback = function()
        cancel_prev()
        local info = vim.fn.complete_info({ 'selected' })
        local completionItem = vim.tbl_get(vim.v.completed_item, 'user_data', 'nvim', 'lsp', 'completion_item')
        if nil == completionItem then
          return
        end
        _, cancel_prev = vim.lsp.buf_request(args.buf,
          vim.lsp.protocol.Methods.completionItem_resolve,
          completionItem,
          function(err, item, ctx)
            if not item then
              return
            end
            local docs = (item.documentation or {}).value
            local win = vim.api.nvim__complete_set(info['selected'], { info = docs })
            if win.winid and vim.api.nvim_win_is_valid(win.winid) then
              vim.treesitter.start(win.bufnr, 'markdown')
              vim.wo[win.winid].conceallevel = 3
            end
          end)
      end
    })

    local event = args
    local map = function(keys, func, desc)
      vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
    end

    map("gR", require("fzf-lua").lsp_references, "[G]oto [R]eferences")
    map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
    map("gd", require("fzf-lua").lsp_definitions, "[G]oto [D]efinition")

    map("gb", "<cmd> pop<CR>", "[G]oto [B]uffer")

    map("gI", require("fzf-lua").lsp_implementations, "[G]oto [I]mplementation")
    map("<leader>DD", require("fzf-lua").lsp_typedefs, "Type [D]efinition")
    map("<leader>Ds", require("fzf-lua").lsp_document_symbols, "[D]ocument [S]ymbols")
    map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
    map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
    map("K", vim.lsp.buf.hover, "Hover Documentation")
    local types = {
      ["c"] = true,
      ["C"] = true,
      ["cc"] = true,
      ["cpp"] = true,
      ["CPP"] = true,
      ["c++"] = true,
      ["cp"] = true,
      ["cxx"] = true,
      ["hpp"] = true,
      ["h"] = true,
      ["hp"] = true,
      ["hxx"] = true,
      ["h++"] = true,
    }
    if types[vim.bo.filetype] then
      map("L", "<CMD>ClangdShowSymbolInfo<CR>", "Show symbol info")
    end
    if client.server_capabilities.documentHighlightProvider then
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        buffer = event.buf,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        buffer = event.buf,
        callback = vim.lsp.buf.clear_references,
      })
    end
  end
})

vim.lsp.inlay_hint.enable(true)
vim.diagnostic.config({
  signs = { Error = "X ", Warn = "! ", Hint = "h ", Info = "i " },
  virtual_lines = { current_line = true },
})

vim.lsp.config('*', {
  capabilities = {
    textDocument = {
      semanticTokens = {
        multilineTokenSupport = true,
      }
    }
  }
})

vim.lsp.config['bashls'] = require('configs.core.lsp-servers.bashls')
vim.lsp.config['clangd'] = require('configs.core.lsp-servers.clangd')
vim.lsp.config['gopls'] = require('configs.core.lsp-servers.gopls')
-- vim.lsp.config['html'] = require('configs.core.lsp-servers.html')
-- vim.lsp.config['jsonls'] = require('configs.core.lsp-servers.jsonls')
vim.lsp.config['luals'] = require('configs.core.lsp-servers.lua_ls')
vim.lsp.config['neocmake'] = require('configs.core.lsp-servers.neocmake')
vim.lsp.config['nil_ls'] = require('configs.core.lsp-servers.nil_ls')
vim.lsp.config['pyright'] = require('configs.core.lsp-servers.pyright')
vim.lsp.config['rust_analyzer'] = require('configs.core.lsp-servers.rust_analyzer')
vim.lsp.config['texlab'] = require('configs.core.lsp-servers.texlab')
-- vim.lsp.config['ts_ls'] = require('configs.core.lsp-servers.ts_ls')
-- vim.lsp.config['volar'] = require('configs.core.lsp-servers.volar')


vim.lsp.enable({
  'bashls',
  'clangd',
  'gopls',
  -- 'html',
  -- 'jsonls',
  'luals',
  'neocmake',
  'nil_ls',
  'pyright',
  'rust_analyzer',
  'texlab',
  -- 'ts_ls',
  -- 'volar',
})
