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
  keys = {
    { "<leader>gb", "<CMD>Gitsigns blame<cr>", desc = "Git blame" }
  },
  config = function(_, opts)
    local gs = require("gitsigns")

    gs.setup(opts)
  end,
}
