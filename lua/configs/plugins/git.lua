return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = true,
  },
  {
    "ThePrimeagen/git-worktree.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("git-worktree").setup({})

      require("telescope").load_extension("git_worktree")
      -- keymap
      local keymap = vim.keymap
      keymap.set("n", "<leader>gw", "<cmd>Telescope git_worktree git_worktrees<cr>", { desc = "Open git worktree" })
      keymap.set(
        "n",
        "<leader>gm",
        "<cmd>Telescope git_worktree create_git_worktree<cr>",
        { desc = "Create git worktree" }
      )
    end,
  },
  {
    "tpope/vim-fugitive",
    config = function()
      local keymap = vim.keymap
      local opts = { noremap = true, silent = true }

      keymap.set("n", "<leader>gs", "<cmd>Git<CR>")
      keymap.set("n", "<leader>gp", function()
        vim.cmd.Git("push")
      end)
      keymap.set("n", "<leader>gF", function()
        vim.cmd.Git("push --force-with-lease")
      end)
      keymap.set("n", "<leader>gP", function()
        vim.cmd.Git({ "pull", "--rebase" })
      end)
      keymap.set("n", "<leader>go", ":Git push -u origin ", opts)
      keymap.set("n", "<leader>gb", ":Git blame<CR>", opts)
      keymap.set("n", "<leader>gl", ":Git log<CR>", opts)
    end,
  },
}
