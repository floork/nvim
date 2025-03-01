-- [[ Basic Autocommands ]]
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("configs-lsp-attach", { clear = true }),
  callback = function(event)
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
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client.server_capabilities.documentHighlightProvider then
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        buffer = event.buf,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        buffer = event.buf,
        callback = vim.lsp.buf.clear_references,
      })
    end
  end,
})

-- Hyprlang LSP
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
  pattern = { "*.hl", "hypr*.conf" },
  callback = function(event)
    --   print(string.format("starting hyprls for %s", vim.inspect(event)))
    vim.lsp.start {
      name = "hyprlang",
      cmd = { "hyprls" },
      root_dir = vim.fn.getcwd(),
    }
  end
})

vim.api.nvim_create_autocmd("BufReadPre", {
  desc = "Autocommand to trigger function when opening a buffer",
  pattern = "*",
  callback = function()
    local shebang = vim.fn.getline(1)
    if shebang:match('^#!.*/bash') then
      vim.bo.filetype = 'sh'
    elseif shebang:match('^#!.*/lua') then
      vim.bo.filetype = 'lua'
    end
  end,
})


local group_cdpwd = vim.api.nvim_create_augroup("group_cdpwd", { clear = true })
vim.api.nvim_create_autocmd("VimEnter", {
  desc = "Set the working directory to the current file's directory",
  group = group_cdpwd,
  pattern = "*",
  callback = function()
    vim.api.nvim_set_current_dir(vim.fn.expand("%:p:h"))
  end,
})
