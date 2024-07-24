return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  keys = {
    { "<leader>gs", "<cmd>Neogit<CR>",      desc = "Neogit" },
    { "<leader>gl", "<cmd>Neogit log<CR>",  desc = "Neogit log" },
    { "<leader>gp", "<cmd>Neogit push<CR>", desc = "Neogit push" },
    { "<leader>gP", "<cmd>Neogit pull<CR>", desc = "Neogit pull" }
  },
  config = function()
    local neogit = require("neogit")

    neogit.setup({
      disable_prompt_on_change = true,
    })
  end,
}
