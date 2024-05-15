return {
  "declancm/maximize.nvim",
  config = function()
    require("maximize").setup()

    local keymap = vim.keymap
    local opts = { noremap = true, silent = true }

    opts.desc = "Toggle maximizer"
    keymap.set("n", "<leader>zz", "<Cmd>lua require('maximize').toggle()<CR>", opts)
  end
}
