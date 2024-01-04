return {
  "ThePrimeagen/harpoon",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    require("telescope").load_extension("harpoon")

    -- set keymaps
    local keymap = vim.keymap -- for conciseness

    keymap.set(
      "n",
      "<leader>hm",
      "<cmd>lua require('harpoon.mark').add_file()<cr>",
      { desc = "Mark file with harpoon" }
    )
    keymap.set(
      "n",
      "<leader>hr",
      "<cmd>lua require('harpoon.mark').remove_file()<cr>",
      { desc = "Remove file from harpoon" }
    )
    keymap.set("n", "<leader>hn", "<cmd>lua require('harpoon.ui').nav_next()<cr>", { desc = "Go to next harpoon mark" })
    keymap.set(
      "n",
      "<leader>hp",
      "<cmd>lua require('harpoon.ui').nav_prev()<cr>",
      { desc = "Go to previous harpoon mark" }
    )
    keymap.set(
      "n",
      "<leader>ha",
      "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>",
      { desc = "Toggle harpoon quick menu" }
    )
    keymap.set("n", "<leader>hh", "<cmd>Telescope harpoon marks<cr>", { desc = "Show harpoon marks" })
  end,
}
