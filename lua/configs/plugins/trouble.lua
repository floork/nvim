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
    keymap.set("n", "<leader>xx", function()
      require("trouble").toggle()
    end, { noremap = true, silent = true })
    keymap.set("n", "[d", function()
      require("trouble").previous({ skip_groups = true, jump = true })
    end, { noremap = true, silent = true })
    keymap.set("n", "]d", function()
      require("trouble").next({ skip_groups = true, jump = true })
    end, { noremap = true, silent = true })
  end,
}
