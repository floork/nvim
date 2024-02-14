return {
  "folke/zen-mode.nvim",
  config = function()
    local keymap = vim.keymap
    local opts = { noremap = true, silent = true }

    opts.desc = "Toggle zen mode"
    keymap.set("n", "<leader>zz", function()
      require("zen-mode").setup({
        window = {
          width = 90,
          options = {},
        },
      })
      require("zen-mode").toggle()
      vim.wo.wrap = false
      vim.wo.number = true
      vim.wo.rnu = true
    end, opts)

    opts.desc = "Toggle zen mode 2"
    keymap.set("n", "<leader>zZ", function()
      require("zen-mode").setup({
        window = {
          width = 80,
          options = {},
        },
      })
      require("zen-mode").toggle()
      vim.wo.wrap = false
      vim.wo.number = false
      vim.wo.rnu = false
      vim.opt.colorcolumn = "0"
    end, opts)
  end,
}
