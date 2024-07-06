return {
  {
    "nvim-lua/plenary.nvim",
    "christoomey/vim-tmux-navigator",
    config = function()
      -- keymaps
      local keymap = vim.keymap
      local opts = { noremap = true, silent = true }

      opts.desc = "Move left in tmux"
      keymap.set("n", "<C-h>", "<CMD>TmuxNavigateLeft<CR>", opts)

      opts.desc = "Move down in tmux"
      keymap.set("n", "<C-j>", "<CMD>TmuxNavigateDown<CR>", opts)

      opts.desc = "Move up in tmux"
      keymap.set("n", "<C-k>", "<CMD>TmuxNavigateUp<CR>", opts)

      opts.desc = "Move right in tmux"
      keymap.set("n", "<C-l>", "<CMD>TmuxNavigateRight<CR>", opts)
    end,
  },
}
