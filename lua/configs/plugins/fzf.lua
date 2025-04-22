local fzf_lsp_augroup =
    vim.api.nvim_create_augroup("FzfLuaLspGroup", { clear = true })

-- Set fzf-lua specific LSP keymaps when LSP attaches
vim.api.nvim_create_autocmd("LspAttach", {
  group = fzf_lsp_augroup,
  desc = "Setup fzf-lua LSP keymaps",
  callback = function(args)
    local bufnr = args.buf

    -- Ensure fzf-lua is available before trying to use it
    local fzf_lua_ok, fzf_lua = pcall(require, "fzf-lua")
    if not fzf_lua_ok then
      -- Optionally notify if fzf-lua is missing
      -- vim.notify("fzf-lua not found. Skipping fzf-lua LSP map setup for buffer " .. bufnr, vim.log.levels.WARN)
      return
    end

    -- Define a buffer-local mapping helper within this function's scope
    local map = function(keys, func, desc)
      vim.keymap.set("n", keys, func, {
        buffer = bufnr,
        desc = "LSP (fzf-lua): " .. desc,         -- Add a clear description
      })
    end

    -- Set the fzf-lua dependent LSP maps
    map("gR", fzf_lua.lsp_references, "[G]oto [R]eferences")
    map("gd", fzf_lua.lsp_definitions, "[G]oto [D]efinition")
    map("gI", fzf_lua.lsp_implementations, "[G]oto [I]mplementation")
    map("<leader>DD", fzf_lua.lsp_typedefs, "Type [D]efinition")
    map("<leader>Ds", fzf_lua.lsp_document_symbols, "[D]ocument [S]ymbols")

    -- Add any other fzf-lua specific LSP maps here
  end,
})


return {
  "ibhagwan/fzf-lua",
  keys = {
    {
      "<leader>fl",
      function()
        require("fzf-lua").files({ previewer = false })
      end,
      desc = "Fuzzy find files"
    },
    {
      "<leader>fa",
      function()
        require("fzf-lua").files({ no_ignore = true, hidden = true, previewer = false })
      end,
      desc = "Fuzzy find files ignore local .fdignore"
    },
    {
      "<leader>fs",
      function()
        -- Fuzzy find string (live grep) with hidden files enabled
        require("fzf-lua").live_grep({ hidden = true })
      end,
      desc = "Fuzzy find string"
    },
    {
      "<leader>/",
      function()
        -- Fuzzily search in the current buffer using grep_curbuf
        require("fzf-lua").grep_curbuf({
          winopts = {
            split  = false,
            border = "single",
          },
          grep = {
            previewer = false,
          },
          previewer = false
        })
      end,
      desc = "[/] Fuzzily search in current buffer"
    },
    {
      "<leader>xx",
      function()
        require("fzf-lua").diagnostics_workspace()
      end,
      desc = "Fuzzy find diagnostics in workspace"
    },
    {
      "z=",
      function()
        require("fzf-lua").spell_suggest()
      end,
      desc = "Fuzzy find spell suggestions"
    }
  },
  config = function()
    local fzf = require("fzf-lua")

    fzf.setup({
      "border-fused",
      fzf_opts = {
        ['--layout'] = 'default',
      },
      winopts = {
        preview = {
          wrap = true,
        },
      },
      previewers = {},
      defaults = {
        git_icons = false,
        file_icons = false,
        color_icons = false,
        formatter = "path.filename_first",
      },
    })
  end
}
