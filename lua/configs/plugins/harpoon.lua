return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  -- "harpoon",
  -- dir = "~/GIT/GitHub/harpoon/",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {},
  config = function()
    local harpoon = require("harpoon")

    harpoon:setup({
      settings = {
        save_on_toggle = true,
      }
    })

    harpoon:extend({
      UI_CREATE = function(cx)
        vim.keymap.set("n", "<C-v>", function()
          harpoon.ui:select_menu_item({ vsplit = true })
        end, { buffer = cx.bufnr })

        vim.keymap.set("n", "<C-x>", function()
          harpoon.ui:select_menu_item({ split = true })
        end, { buffer = cx.bufnr })

        vim.keymap.set("n", "<C-t>", function()
          harpoon.ui:select_menu_item({ tabedit = true })
        end, { buffer = cx.bufnr })
      end,
    })

    local keymap = vim.keymap
    local opts = { noremap = true, silent = true }

    opts.desc = "Add current file to primary harpoon list"
    keymap.set("n", "<leader>hm", function() harpoon:list("primary"):add() end, opts)
    opts.desc = "Toggle primary harpoon menu"
    keymap.set("n", "<leader>hl", function() harpoon.ui:toggle_quick_menu(harpoon:list("primary")) end, opts)
    opts.desc = "Go to harpoon previous entry"
    keymap.set("n", "<leader>hp", function() harpoon:list("primary"):prev() end, opts)
    opts.desc = "Go to harpoon next entry"
    keymap.set("n", "<leader>hn", function() harpoon:list("primary"):next() end, opts)


    opts.desc = "Add current file to secondary harpoon list"
    keymap.set("n", "<leader>ho", function() harpoon:list("secondary"):add() end, opts)
    opts.desc = "Toggle secondary harpoon menu"
    keymap.set("n", "<leader>hi", function() harpoon.ui:toggle_quick_menu(harpoon:list("secondary")) end, opts)
  end,
}
