-- Check Neovim version: require 0.11+ for this config
local v = vim.version()
if v.major == 0 and v.minor < 11 then
  vim.notify("Neovim 0.11+ is required for this config. Aborting.",
    vim.log.levels.WARN)
  return
end

-- Enable inlay hints
vim.lsp.inlay_hint.enable(true)

-- Configure diagnostics
vim.diagnostic.config({
  signs = { Error = "X ", Warn = "! ", Hint = "h ", Info = "i " },
  virtual_lines = { current_line = true },
})

-- Global LSP capabilities configuration
vim.lsp.config('*', {
  capabilities = {
    textDocument = {
      semanticTokens = {
        multilineTokenSupport = true,
      },
    },
  },
})

-- Enable the configured servers.
vim.lsp.enable({
  "bashls",
  "clangd",
  "gopls",
  "html",
  "jsonls",
  "luals",
  "neocmake",
  "nil_ls",
  "pyright",
  "rust_analyzer",
  "texlab",
})

-- LSP key mappings and additional LSP behaviors when LSP attaches to a buffer.
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("configs-lsp-attach", { clear = true }),
  callback = function(args)
    local client =
        assert(vim.lsp.get_client_by_id(args.data.client_id))
    local event = args

    local map = function(keys, func, desc)
      vim.keymap.set("n", keys, func, {
        buffer = event.buf,
        desc = "LSP: " .. desc,
      })
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
      ["c"]   = true,
      ["C"]   = true,
      ["cc"]  = true,
      ["cpp"] = true,
      ["CPP"] = true,
      ["c++"] = true,
      ["cp"]  = true,
      ["cxx"] = true,
      ["hpp"] = true,
      ["h"]   = true,
      ["hp"]  = true,
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
  end,
})
