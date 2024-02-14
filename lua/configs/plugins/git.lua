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
      local opts = { noremap = true, silent = true }
      opts.desc = "Open git worktree"
      keymap.set("n", "<leader>gw", "<cmd>Telescope git_worktree git_worktrees<cr>", opts)
      opts.desc = "Create git worktree"
      keymap.set(
        "n",
        "<leader>gm",
        "<cmd>Telescope git_worktree create_git_worktree<cr>",
        opts
      )
    end,
  },
  {
    "tpope/vim-fugitive",
    config = function()
      local keymap = vim.keymap
      local opts = { noremap = true, silent = true }

      opts.desc = "Git status"
      keymap.set("n", "<leader>gs", "<cmd>Git<CR>", opts)
      opts.desc = "Git push"
      keymap.set("n", "<leader>gp", function()
          vim.cmd.Git("push")
        end,
        opts)
      opts.desc = "Git push --force-with-lease"
      keymap.set("n", "<leader>gF", function()
          vim.cmd.Git("push --force-with-lease")
        end,
        opts)
      opts.desc = "Git pull --rebase"
      keymap.set("n", "<leader>gP", function()
          vim.cmd.Git({ "pull", "--rebase" })
        end,
        opts)
      opts.desc = "Git push origin"
      keymap.set("n", "<leader>go", ":Git push -u origin ", opts)
      opts.desc = "Git blame"
      keymap.set("n", "<leader>gb", ":Git blame<CR>", opts)
      opts.desc = "Git log"
      keymap.set("n", "<leader>gl", ":Git log<CR>", opts)
    end,
  },
}
