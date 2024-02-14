return {
  "mbbill/undotree",
  config = function()
    local keymap = vim.keymap
    local opts = { noremap = true, silent = true }

    opts.desc = "Toggle undotree"
    keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, opts)
  end,
}
