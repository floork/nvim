return {
  -- Plugin repository
  "nvim-telescope/telescope.nvim",
  -- Specify branch
  branch = "0.1.x",
  -- Plugin dependencies
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
        file_ignore_patterns = {
          ".git/", "build/", "dist", "node_modules", ".cache", "%.o", "%.a",
          "%.out", "%.class", "%.pdf", "%.mkv", "%.mp4", "%.zip"
        },
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

    -- Load Telescope extensions
    telescope.load_extension("fzf")

    -- Set keymaps for Telescope
    local keymap = vim.keymap                      -- For conciseness
    local opts = { noremap = true, silent = true } -- Keymap options
    local builtins = require("telescope.builtin")  -- Telescope built-in pickers

    -- Keymap for fuzzy finding files
    opts.desc = "Fuzzy find files"
    keymap.set("n", "<leader>fl",
      function()
        builtins.find_files({
          find_command = { 'fd', '--hidden', '--type', 'file' },
          previewer = false,
        })
      end,
      opts)

    -- Keymap for fuzzy finding files ignoring local .fdignore
    opts.desc = "Fuzzy find files ignore local .fdignore"
    keymap.set("n", "<leader>fa",
      function()
        builtins.find_files({
          find_command = { 'fd', '--no-ignore', '--hidden', '--type', 'file' },
          previewer = false,
        })
      end,
      opts)

    -- Keymap for fuzzy finding a string
    opts.desc = "Fuzzy find string"
    keymap.set("n", "<leader>fs", function()
      builtins.live_grep({ hidden = true, })
    end, opts)

    -- Keymap for fuzzy search in current buffer
    opts.desc = "[/] Fuzzily search in current buffer"
    vim.keymap.set('n', '<leader>/', function()
      builtins.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        previewer = false,
      })
    end)

    -- Keymap for searching Neovim configuration files
    opts.desc = "[S]earch [N]eovim files"
    keymap.set("n", "<leader>fc", function()
      builtins.find_files({ cwd = vim.fn.stdpath("config") })
    end, opts)
  end,
}
