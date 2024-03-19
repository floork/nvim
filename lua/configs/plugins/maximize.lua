return {
  "szw/vim-maximizer",
  config = function()
    local keymap = vim.keymap
    local opts = { noremap = true, silent = true }

    opts.desc = "Toggle maximizer"
    keymap.set("n", "<leader>zz", ":MaximizerToggle<CR>", opts)
  end
}
