if _G.USE_BUILDINS then
  -- Add this to your init.lua
  vim.keymap.set("n", "<leader>fl", ":FileSearch<CR>", { noremap = true, silent = true })
  return {}
end

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
