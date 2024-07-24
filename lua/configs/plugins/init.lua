return {
  {
    "nvim-lua/plenary.nvim"
  },
  {
    "christoomey/vim-tmux-navigator",
    keys = {
      { "<C-h>", "<CMD>TmuxNavigateLeft<CR>",  desc = "Move left in tmux" },
      { "<C-j>", "<CMD>TmuxNavigateDown<CR>",  desc = "Move down in tmux" },
      { "<C-k>", "<CMD>TmuxNavigateUp<CR>",    desc = "Move up in tmux" },
      { "<C-l>", "<CMD>TmuxNavigateRight<CR>", desc = "Move right in tmux" }
    },
  },
}
