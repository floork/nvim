return {
  "polarmutex/git-worktree.nvim",
  branch = "v2",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    require("git-worktree").setup({})
  end,
}
