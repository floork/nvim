return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/nvim-cmp",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      { "j-hui/fidget.nvim", opts = {} },
    },
    config = function()
      -- used to enable autocompletion (assign to every lsp server config)
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

      -- Change the Diagnostic symbols in the sign column (gutter)
      local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
      end

      local servers = {
        html = {},
        pyright = {},
        clangd = {},
        neocmake = {},
        gopls = {
          experimentalPostfixCompletions = true,
          analyses = {
            unusedparams = true,
            shadow = true,
          },
          staticcheck = true,
        },
        bashls = {},
        dockerls = {},
        -- rust_analyser = {},
        nil_ls = {},
        volar = {
          filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
        },
        jsonls = {},
        yamlls = {},
        lua_ls = {
          settings = {
            Lua = {
              runtime = { version = "LuaJIT" },
              workspace = {
                checkThirdParty = false,
                -- Tells lua_ls where to find all the Lua files that you have loaded
                -- for your neovim configuration.
                library = {
                  "${3rd}/luv/library",
                  unpack(vim.api.nvim_get_runtime_file("", true)),
                },
                -- If lua_ls is really slow on your computer, you can try this instead:
                -- library = { vim.env.VIMRUNTIME },
              },
              completion = {
                callSnippet = "Replace",
              },
              -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
              -- diagnostics = { disable = { 'missing-fields' } },
              useTab = false,
              tabWidth = 2,
              diagnostics = {
                globals = { "vim" },
              },
            },
          },
        },
      }

      local mason = require("mason")
      mason.setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
          border = "single",
        },
      })
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        "bashls",
        "clangd",
        "cssls",
        "dockerls",
        "docker_compose_language_service",
        "emmet_ls",
        "gopls",
        "html",
        "jsonls",
        "lua_ls",
        "marksman",
        "neocmake",
        "pyright",
        "nil_ls",
        "rust_analyzer",
        "tsserver",
        "volar",
        "yamlls",
        --
        "black",        -- Python code formatter
        "clang-format", -- C++ code formatter
        "codespell",    -- Spell checker for code
        "debugpy",      -- Python debugger
        "eslint",       -- JavaScript code linter
        "yamllint",     -- YAML code linter
        "markdownlint", -- Markdown linter
        "isort",        -- Python code formatter
        "pylint",       -- Python code linter
        "nixpkgs-fmt",  -- Nix code formatter
        "stylua",       -- Lua code formatter
      })
      require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

      require("mason-lspconfig").setup({
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
            require("lspconfig")[server_name].setup(server)
          end,
        },
      })
    end,
  },
}
