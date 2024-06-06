return {
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
    },
    config = function(_, opts)
      local gs = require("gitsigns")

      gs.setup(opts)

      -- keymaps
      local keymap = vim.keymap
      local opt = { noremap = true, silent = true }

      opt.desc = "Git blame"
      keymap.set('n', '<leader>gb', function() gs.blame_line { full = true } end, opt)
    end,
  },
  {
    "polarmutex/git-worktree.nvim",
    branch = "v2",
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
      keymap.set("n", "<leader>gw",
        function() require('telescope').extensions.git_worktree.git_worktrees() end,
        opts)
      opts.desc = "Create git worktree"
      keymap.set("n", "<leader>gm",
        function() require('telescope').extensions.git_worktree.create_git_worktree() end,
        opts)
    end,
  },
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim",
      "ibhagwan/fzf-lua",
    },
    config = function()
      local neogit = require("neogit")

      neogit.setup({
        integrations = {
          diffview = true,
          telescope = true,
        },
        disable_prompt_on_change = true,
      })

      -- keymap
      local keymap = vim.keymap
      local opts = { noremap = true, silent = true }

      opts.desc = "Neogit"
      keymap.set("n", "<leader>gs", "<cmd>Neogit<CR>", opts)

      opts.desc = "Neogit log"
      keymap.set("n", "<leader>gl", "<cmd>Neogit log<CR>", opts)

      opts.desc = "Neogit push"
      keymap.set("n", "<leader>gp", "<cmd>Neogit push<CR>", opts)

      opts.desc = "Neogit pull"
      keymap.set("n", "<leader>gP", "<cmd>Neogit pull<CR>", opts)
    end,
  }
}
