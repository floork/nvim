return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
    "nvim-telescope/telescope-dap.nvim",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    telescope.setup({
      defaults = {
        -- path_display = { "truncate " },
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous, -- move to prev result
            ["<C-j>"] = actions.move_selection_next,     -- move to next result
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
          },
        },
      },
    })

    telescope.load_extension("fzf")
    telescope.load_extension("dap")

    -- set keymaps
    local keymap = vim.keymap -- for conciseness
    local opts = { noremap = true, silent = true, }
    local builtins = require("telescope.builtin")

    opts.desc = "Fuzzy find files"
    keymap.set("n", "<leader>fl", "<cmd>Telescope find_files find_command=rg,--ignore,--hidden,--files,-u<cr>",
      opts)
    opts.desc = "Fuzzy find git files"
    keymap.set("n", "<leader>ff", builtins.git_files, opts)
    opts.desc = "Fuzzy find string"
    keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep hidden=true<cr>", opts)
    opts.desc = "find dap breakpoints"
    keymap.set("n", "<leader>bf", "<cmd>Telescope dap list_breakpoints<cr>", opts)
  end,
}
