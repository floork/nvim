return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require("harpoon")

    harpoon:setup({})

    local keymap = vim.keymap
    keymap.set("n", "<leader>hm", function() harpoon:list():append() end)
    keymap.set("n", "<leader>hl", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
    keymap.set("n", "<leader>hp", function() harpoon:list():prev() end)
    keymap.set("n", "<leader>hn", function() harpoon:list():next() end)
  end,
}
