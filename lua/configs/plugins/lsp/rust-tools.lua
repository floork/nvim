return {
  "neovim/nvim-lspconfig",
  "simrat39/rust-tools.nvim",

  -- Debugging
  "nvim-lua/plenary.nvim",
  "mfussenegger/nvim-dap",
  config = function()
    local rt = require("rust-tools")

    rt.setup({
      server = {
        on_attach = function(_, bufnr)
          local keymap = vim.keymap
          local opts = { noremap = true, silent = true }
          -- Hover actions
          opts.buffer = bufnr
          opts.desc = "Show hover actions"
          keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, opts)
          -- Code action groups
          opts.desc = "Show code action groups"
          keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, opts)
        end,
      },
      opts = {
        tools = {
          inlay_hints = {
            highlight = "#ff0000",
            only_current_line = false,
          },
        },
      },
    })
    -- Commands:
    -- RustEnableInlayHints
    -- RustDisableInlayHints
    -- RustSetInlayHints
    -- RustUnsetInlayHints
    rt.inlay_hints.set()
    rt.inlay_hints.enable()
  end,
}
