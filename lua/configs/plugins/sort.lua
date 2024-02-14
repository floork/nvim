return {
  "sQVe/sort.nvim",
  config = function()
    require("sort").setup()

    -- keymaps
    local keymap = vim.keymap
    local opts = { noremap = true, silent = true }

    opts.desc = "Sort lines"
    keymap.set({ "n", "v" }, "<leader>o", "<cmd>lua require('sort').sort_lines()<CR>", opts)
  end,
}
