return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  },
  config = function()
    -- keymap
    local keymap = vim.keymap
    local opts = { noremap = true, silent = true }

    opts.desc = "Toggle trouble"
    keymap.set("n", "<leader>xx", function()
      require("trouble").toggle()
    end, opts)
    opts.desc = "Toggle quickfix"
    keymap.set("n", "<leader>[f", function()
      require("trouble").toggle("quickfix")
    end, opts)
    opts.desc = "previous trouble"
    keymap.set("n", "[d", function()
      require("trouble").previous({ skip_groups = true, jump = true })
    end, opts)
    opts.desc = "next trouble"
    keymap.set("n", "]d", function()
      require("trouble").next({ skip_groups = true, jump = true })
    end, opts)
  end,
}
