-- Lua function to check if a `.clang-format` file exists
local function clang_format_command()
  local handle = io.popen('test -f .clang-format && echo "found" || echo "not found"')
  if handle == nil then
    return { "-style=llvm" }
  end
  local result = handle:read("*a"):match("^%s*(.-)%s*$")
  handle:close()
  if result == "found" then
    return { "-style=file" }
  else
    return { "-style=llvm" }
  end
end

return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  keys = {
    {
      "<leader>mf",
      function()
        require("conform").format({
          lsp_format = "fallback",
          async = false,
          timeout_ms = 1000,
        })
      end,
      mode = { "n", "v" },
      desc = "Format file or range (in visual mode)",
    },
  },
  config = function()
    local conform = require("conform")
    -- Define the tex formatter without a trailing space in the key
    conform.formatters.tex_fmt = {
      inherit = false,
      command = "tex-fmt",
      args = { "--nowrap", "--stdin" },
      stdin = true,
    }

    conform.setup({
      formatters_by_ft = {
        bash = { "shfmt" },                                       -- Bash formatter (shfmt)
        sh = { "shfmt" },                                         -- Shell formatter (shfmt)
        zsh = { "shfmt" },                                        -- Zsh formatter (shfmt)
        c = { "my_cpp" },                                         -- C formatter (clang-format)
        cpp = { "my_cpp" },                                       -- C++ formatter (clang-format)
        css = { "prettier" },                                     -- CSS formatter (prettier)
        go = { "gofmt" },                                         -- Go formatter (gofmt)
        html = { "prettier" },                                    -- HTML formatter (prettier)
        javascript = { "prettier" },                              -- JavaScript formatter (prettier)
        json = { "prettier" },                                    -- JSON formatter (prettier)
        jsonc = { "prettier" },                                   -- JSON formatter (prettier)
        lua = { "stylua --indent-width 2 --indent-type Spaces" }, -- Lua formatter (stylua)
        markdown = { "prettier" },                                -- Markdown formatter (prettier)
        nix = { "nixfmt" },                                       -- Nix formatter (nixfmt)
        python = { "isort", "black" },                            -- Python formatters (isort, black)
        rust = { "rust_analyzer" },                               -- Rust formatter (rustfmt)
        tex = { "tex_fmt" },                                      -- LaTeX formatter (tex-fmt)
        toml = { "taplo" },                                       -- TOML formatter (prettier)
        yml = { "prettier" },                                     -- YAML formatter (prettier)
      },

      format_on_save = function(bufnr)
        -- Disable with a global or buffer-local variable
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end

        return {
          lsp_fallback = true,
          async = false,
          timeout_ms = 1000,
        }
      end,
    })

    conform.formatters.my_cpp = {
      command = "clang-format",
      args = clang_format_command(),
      stdin = true,
    }

    vim.api.nvim_create_user_command("FormatDisable", function(args)
      if args.bang then
        -- FormatDisable! will disable formatting just for this buffer
        vim.b.disable_autoformat = true
      else
        vim.g.disable_autoformat = true
      end
    end, {
      desc = "Disable autoformat-on-save",
      bang = true,
    })

    vim.api.nvim_create_user_command("FormatEnable", function()
      vim.b.disable_autoformat = false
      vim.g.disable_autoformat = false
    end, {
      desc = "Re-enable autoformat-on-save",
    })
  end,
}
