return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require("harpoon")

    harpoon:setup({})

    local keymap = vim.keymap
    local opts = { noremap = true, silent = true }

    opts.desc = "Add current file to harpoon"
    keymap.set("n", "<leader>hm", function() harpoon:list():append() end, opts)
    opts.desc = "Toggle harpoon menu"
    keymap.set("n", "<leader>hl", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, opts)
    opts.desc = "Go to harpoon previous entry"
    keymap.set("n", "<leader>hp", function() harpoon:list():prev() end, opts)
    opts.desc = "Go to harpoon next entry"
    keymap.set("n", "<leader>hn", function() harpoon:list():next() end, opts)
  end,
}
