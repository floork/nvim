return {
  "jiaoshijie/undotree",
  dependencies = "nvim-lua/plenary.nvim",
  config = function()
    local keymap = vim.keymap
    local opts = { noremap = true, silent = true }
    opts.desc = "Toggle undotree"
    keymap.set("n", "<leader>u", "<CMD>UndotreeToggle<cr>", opts)
  end,
}
