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
      keymap.set("n", "<leader>gm", "<cmd>Telescope git_worktree create_git_worktree<cr>", opts)
    end,
  },
  -- {
  --   "tpope/vim-fugitive",
  --   config = function()
  --     local keymap = vim.keymap
  --     local opts = { noremap = true, silent = true }
  --
  --     opts.desc = "Git status"
  --     keymap.set("n", "<leader>gs", "<cmd>Git<CR>", opts)
  --     opts.desc = "Git push"
  --     keymap.set("n", "<leader>gp", function()
  --       vim.cmd.Git("push")
  --     end, opts)
  --     opts.desc = "Git push --force-with-lease"
  --     keymap.set("n", "<leader>gfp", function()
  --       vim.cmd.Git("push --force-with-lease")
  --     end, opts)
  --     opts.desc = "Git push --force"
  --     keymap.set("n", "<leader>gFp", function()
  --       vim.cmd.Git("push --force")
  --     end, opts)
  --     opts.desc = "Git pull --rebase"
  --     keymap.set("n", "<leader>gP", function()
  --       vim.cmd.Git("pull --rebase")
  --     end, opts)
  --     opts.desc = "Git push origin"
  --     keymap.set("n", "<leader>go", ":Git push -u origin ", opts)
  --     opts.desc = "Git blame"
  --     keymap.set("n", "<leader>gb", ":Git blame<CR>", opts)
  --     opts.desc = "Git log"
  --     keymap.set("n", "<leader>gl", ":Git log<CR>", opts)
  --   end,
  -- },
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
        kind = "floating",
        commit_editor = {
          kind = "floating",
        },
        commit_select_view = {
          kind = "floating",
        },
        commit_view = {
          kind = "floating",
        },
        log_view = {
          kind = "floating",
        },
        rebase_editor = {
          kind = "floating",
        },
        reflog_view = {
          kind = "floating",
        },
        merge_editor = {
          kind = "floating",
        },
        tag_editor = {
          kind = "floating",
        },
        preview_buffer = {
          kind = "floating",
        },
        popup = {
          kind = "floating",
        },
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
