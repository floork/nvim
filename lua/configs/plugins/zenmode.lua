return {
  "folke/zen-mode.nvim",
  config = function()
    local keymap = vim.keymap

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
      -- ColorMyPencils()
    end)

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
      -- ColorMyPencils()
    end)
  end,
}
