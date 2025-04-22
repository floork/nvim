-- Check Neovim version: require 0.11+ for this config
local v = vim.version()
if v.major == 0 and v.minor < 11 then
  vim.notify(
    "Neovim 0.11+ is required for this config. Aborting.",
    vim.log.levels.WARN
  )
  return
end

-- Keep track of buffers waiting for their first diagnostic update after LSP attach
local pending_lsp_ready_notify = {} -- Key: bufnr, Value: client_id (or true)

-- Enable inlay hints
vim.lsp.inlay_hint.enable(true)

-- Configure diagnostics
vim.diagnostic.config({
  signs = { Error = "X ", Warn = "! ", Hint = "h ", Info = "i " },
  virtual_lines = { current_line = true },
  workspace = { enable = true },
})

-- Global LSP capabilities configuration
vim.lsp.config("*", {
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

-- Autocommand group for LSP related actions
local lsp_augroup =
    vim.api.nvim_create_augroup("MyLspConfigGroup", { clear = true })

-- LSP key mappings and marking buffer for ready notification
vim.api.nvim_create_autocmd("LspAttach", {
  group = lsp_augroup,
  desc = "Setup LSP keymaps and mark buffer for ready notification",
  callback = function(args)
    local client_id = args.client_id or (args.data and args.data.client_id)
    local bufnr = args.buf

    if not client_id then
      vim.notify(
        "LspAttach event missing client_id.",
        vim.log.levels.WARN,
        { title = "LSP Config Error" }
      )
      return
    end

    local client = vim.lsp.get_client_by_id(client_id)
    if not client then
      vim.notify(
        "Could not get LSP client object for ID: " .. tostring(client_id),
        vim.log.levels.WARN,
        { title = "LSP Config Error" }
      )
      return
    end

    -- Mark this buffer and client as needing a "ready" notification
    -- Store client_id to potentially show the correct name later
    if not pending_lsp_ready_notify[bufnr] then
      pending_lsp_ready_notify[bufnr] = {}
    end
    pending_lsp_ready_notify[bufnr][client_id] = true -- Mark this client as pending for this buffer

    -- --- LSP Keymap Setup ---
    local map = function(keys, func, desc)
      vim.keymap.set("n", keys, func, {
        buffer = bufnr,
        desc = "LSP: " .. desc,
      })
    end

    map("gb", "<cmd> pop<CR>", "[G]oto [B]uffer")
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
    if types[vim.bo[bufnr].filetype] then
      map("L", "<CMD>ClangdShowSymbolInfo<CR>", "Show symbol info")
    end

    if client.server_capabilities.documentHighlightProvider then
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        group = lsp_augroup, -- Assign to the group
        buffer = bufnr,
        desc = "Highlight references under cursor",
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        group = lsp_augroup, -- Assign to the group
        buffer = bufnr,
        desc = "Clear reference highlights",
        callback = vim.lsp.buf.clear_references,
      })
    end
    -- --- End LSP Keymap Setup ---
  end,
})

-- Notify when diagnostics are first published after LSP attach
vim.api.nvim_create_autocmd("DiagnosticChanged", {
  group = lsp_augroup,
  pattern = "*", -- Apply to all buffers
  desc = "Notify when LSP seems ready (first diagnostics received)",
  callback = function(args)
    local bufnr = args.buf
    -- Check if we are waiting for a notification for this buffer
    if pending_lsp_ready_notify[bufnr] then
      -- Check if there are actually diagnostics now
      -- Use severity filter to avoid triggering on hints/info if desired
      local diags = vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.WARN }) -- Or INFO/ERROR
      if #diags > 0 then
        -- Find *which* client(s) were pending for this buffer
        local notified_clients = {}
        for client_id, _ in pairs(pending_lsp_ready_notify[bufnr]) do
          local client = vim.lsp.get_client_by_id(client_id)
          if client and client.name then
            table.insert(notified_clients, client.name)
          else
            table.insert(notified_clients, "LSP Client " .. client_id) -- Fallback name
          end
        end

        if #notified_clients > 0 then
          local bufname = vim.api.nvim_buf_get_name(bufnr)
          local filename = vim.fn.fnamemodify(bufname, ":t")
          if filename == "" then
            filename = "[No Name]"
          end

          -- Create the notification message
          local server_names = table.concat(notified_clients, ", ")
          vim.notify(
            string.format("LSP ready: %s for %s", server_names, filename),
            vim.log.levels.INFO,
            { title = "LSP Status" }
          )

          -- Stop waiting for notifications for this buffer
          pending_lsp_ready_notify[bufnr] = nil
        end
      end
    end
  end,
})

vim.api.nvim_create_user_command('LspRestart', function()
  vim.notify('Currently TO BE IMPLEMENTED', vim.log.levels.WARN, { title = 'LSP Config Error' })
end, {
  desc = 'Currently TO BE IMPLEMENTED',
})

vim.api.nvim_create_user_command("LspInfo", function()
  vim.api.nvim_command("checkhealth vim.lsp")
end, {
  desc = 'Print LSP clients for the current buffer',
})
