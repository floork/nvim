return {
  "sQVe/sort.nvim",
  config = function()
    require("sort").setup()

    -- keymaps
    local opts = { noremap = true, silent = true }
    local keymap = vim.keymap

    keymap.set({ "n", "v" }, "<leader>o", "<cmd>lua require('sort').sort_lines()<CR>", opts)
  end,
}
