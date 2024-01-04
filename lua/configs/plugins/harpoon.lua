return {
  "ThePrimeagen/harpoon",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    local keymap = vim.keymap
    local mark = require("harpoon.mark")
    local ui = require("harpoon.ui")

    keymap.set("n", "<leader>hm", mark.add_file, { desc = "Mark file with harpoon" })
    keymap.set("n", "<leader>hn", ui.nav_next, { desc = "Go to next harpoon mark" })
    keymap.set("n", "<leader>hp", ui.nav_prev, { desc = "Go to previous harpoon mark" })
    keymap.set("n", "<leader>hh", ui.toggle_quick_menu, { desc = "Toggle harpoon quick menu" })
  end,
}
