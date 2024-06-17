return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    -- keymap
    local keymap = vim.keymap
    local opts = { noremap = true, silent = true }

    opts.desc = "Toggle trouble"
    keymap.set("n", "<leader>xx", function()
      require("trouble").toggle("diagnostics")
    end, opts)
    opts.desc = "Toggle quickfix"
    keymap.set("n", "<leader>[f", function()
      require("trouble").toggle("quickfix")
    end, opts)
  end,
}
