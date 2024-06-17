return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "sindrets/diffview.nvim",
    "ibhagwan/fzf-lua",
  },
  config = function()
    local neogit = require("neogit")

    neogit.setup({
      integrations = {
        diffview = true,
      },
      disable_prompt_on_change = true,
    })

    -- keymap
    local keymap = vim.keymap
    local opts = { noremap = true, silent = true }

    opts.desc = "Neogit"
    keymap.set("n", "<leader>gs", "<cmd>Neogit<CR>", opts)

    opts.desc = "Neogit log"
    keymap.set("n", "<leader>gl", "<cmd>Neogit log<CR>", opts)

    opts.desc = "Neogit push"
    keymap.set("n", "<leader>gp", "<cmd>Neogit push<CR>", opts)

    opts.desc = "Neogit pull"
    keymap.set("n", "<leader>gP", "<cmd>Neogit pull<CR>", opts)
  end,
}
