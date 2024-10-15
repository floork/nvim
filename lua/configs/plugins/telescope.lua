return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  keys = {
    {
      "<leader>fl",
      function()
        require("telescope.builtin").find_files({
          find_command = { 'fd', '--hidden', '--type', 'file' },
          previewer = false,
        })
      end,
      desc = "Fuzzy find files"
    },
    {
      "<leader>fa",
      function()
        require("telescope.builtin").find_files({
          find_command = { 'fd', '--no-ignore', '--hidden', '--type', 'file' },
          previewer = false,
        })
      end,
      desc = "Fuzzy find files ignore local .fdignore"
    },
    {
      "<leader>fs",
      function()
        require("telescope.builtin").live_grep({ hidden = true, })
      end,
      desc = "Fuzzy find string"
    },
    {
      '<leader>/',
      function()
        require("telescope.builtin").current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          previewer = false,
        })
      end,
      desc = "[/] Fuzzily search in current buffer"
    },
    {
      "<leader>fc",
      function()
        require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })
      end,
      desc = "[S]earch [N]eovim files"
    }
  },
  dependencies = {
    "nvim-lua/plenary.nvim", -- Required Lua functions for Neovim
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",                         -- Build with 'make'
      cond = function()
        return vim.fn.executable("make") == 1 -- Only build if 'make' is available
      end,
    },
  },
  -- Plugin configuration
  config = function()
    -- Import Telescope and actions
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    -- Telescope setup
    telescope.setup({
      defaults = {
        -- Display truncated paths
        -- path_display = { "truncate " },
        -- Ignore specified file patterns
        -- file_ignore_patterns = {
        --   ".git/", "build/", "dist", "node_modules", ".cache", "%.o", "%.a",
        --   "%.out", "%.class", "%.pdf", "%.mkv", "%.mp4", "%.zip"
        -- },
        -- Key mappings for insert mode
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous,                       -- Move to previous result
            ["<C-j>"] = actions.move_selection_next,                           -- Move to next result
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist, -- Send selected to quickfix list
          },
        },
      },
    })
  end,
}
