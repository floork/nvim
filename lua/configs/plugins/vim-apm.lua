return {
  "theprimeagen/vim-apm",
  config = function()
    local apm = require("vim-apm")

    apm:setup({})

    local keymap = vim.keymap
    local opts = { noremap = true, silent = true }

    opts.desc = "Toggle APM"
    keymap.set("n", "<leader>apm", function() apm:toggle_monitor() end, opts)
  end
}
