return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp",
      -- "simrat39/rust-tools.nvim",
      -- "nvim-lua/plenary.nvim",
      -- "mfussenegger/nvim-dap",
      -- { "antosha417/nvim-lsp-file-operations", config = true },
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      { "j-hui/fidget.nvim", opts = {} },
    },
    config = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("configs-lsp-attach", { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          map("gR", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
          map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
          map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")

          map("gb", "<cmd> pop<CR>", "[G]oto [B]uffer")

          map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
          map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
          map("<leader>Ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
          map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
          map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
          map("K", vim.lsp.buf.hover, "Hover Documentation")
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
        ansiblels = {},
        html = {},
        tsserver = {},
        pyright = {},
        clangd = {},
        cmake = {},
        gopls = {},
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
        "graphql",
        "html",
        "htmx-lsp",
        "jsonls",
        "lua_ls",
        "marksman",
        "neocmake",
        "prismals",
        "pyright",
        "nil_ls",
        "rust_analyzer",
        "svelte",
        "tailwindcss",
        "taplo",
        "tsserver",
        "volar",
        "yamlls",
        "zls",
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

      -- require("mason-lspconfig").setup_handlers({
      --   function(server_name)
      --     require("lspconfig")[server_name].setup({ on_attach = on_attach, capabilities = capabilities })
      --   end,
      --
      --   ["rust_analyzer"] = function()
      --     require("rust-tools").setup()
      --   end,
      -- })
      --
      -- local rt = require("rust-tools")
      --
      -- rt.setup({
      --   server = {
      --     on_attach = function(_, bufnr)
      --       -- Hover actions
      --       keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
      --       -- Code action groups
      --       keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
      --     end,
      --   },
      --   opts = {
      --     tools = {
      --       inlay_hints = {
      --         highlight = "#ff0000",
      --         only_current_line = false,
      --       },
      --     },
      --   },
      -- })
      -- rt.inlay_hints.set()
      -- rt.inlay_hints.enable()
    end,
  },
}
