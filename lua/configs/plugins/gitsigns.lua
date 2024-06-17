return {
  "lewis6991/gitsigns.nvim",
  opts = {
    signs = {
      add = { text = "+" },
      change = { text = "~" },
      delete = { text = "_" },
      topdelete = { text = "‾" },
      changedelete = { text = "~" },
    },
  },
  config = function(_, opts)
    local gs = require("gitsigns")

    gs.setup(opts)

    -- keymaps
    local keymap = vim.keymap
    local opt = { noremap = true, silent = true }

    opt.desc = "Git blame"
    keymap.set('n', '<leader>gb', function() gs.blame_line { full = true } end, opt)
  end,
}
