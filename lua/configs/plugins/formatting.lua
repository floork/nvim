return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")

    conform.setup({
      formatters_by_ft = {
        bash = { "shfmt" },                                       -- Bash formatter (shfmt)
        sh = { "shfmt" },                                         -- Shell formatter (shfmt)
        zsh = { "shfmt" },                                        -- Zsh formatter (shfmt)
        c = { "my_cpp" },                                         -- C formatter (clang-format)
        cpp = { "my_cpp" },                                       -- C++ formatter (clang-format)
        css = { "prettier" },                                     -- CSS formatter (prettier)
        go = { "gofmt" },                                         -- Go formatter (gofmt)
        graphql = { "prettier" },                                 -- GraphQL formatter (prettier)
        html = { "prettier" },                                    -- HTML formatter (prettier)
        javascript = { "prettier" },                              -- JavaScript formatter (prettier)
        json = { "prettier" },                                    -- JSON formatter (prettier)
        lua = { "stylua --indent-width 2 --indent-type Spaces" }, -- Lua formatter (stylua)
        markdown = { "prettier" },                                -- Markdown formatter (prettier)
        nix = { "nixfmt" },                                       -- Nix formatter (nixfmt)
        python = { "isort", "black" },                            -- Python formatters (isort, black)
        rust = { "rust_analyzer" },                               -- Rust formatter (rustfmt)
        toml = { "prettier" },                                    -- TOML formatter (prettier)
        yml = { "prettier" },                                     -- YAML formatter (prettier)
      },
      format_on_save = {
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
      },
    })

    conform.formatters.my_cpp = {
      command = "clang-format",
      args = { "-style=Google" },
      stdin = true,
    }

    local keymap = vim.keymap
    local opts = { noremap = true, silent = true }

    opts.desc = "Format file or range (in visual mode)"
    keymap.set({ "n", "v" }, "<leader>mf", function()
      conform.format({
        lsp_format = "fallback",
        async = false,
        timeout_ms = 1000,
      })
    end, opts)
  end,
}
