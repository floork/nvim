return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local keymap = vim.keymap
    local harpoon = require("harpoon")
    local ui = require("harpoon.ui")

    keymap.set("n", "<leader>a", function() harpoon:list():append() end)
    keymap.set("n", "<leader>hn", ui.nav_next, { desc = "Go to next harpoon mark" })
    keymap.set("n", "<leader>hp", ui.nav_prev, { desc = "Go to previous harpoon mark" })
    keymap.set("n", "<leader>hh", ui.toggle_quick_menu, { desc = "Toggle harpoon quick menu" })
  end,
}
