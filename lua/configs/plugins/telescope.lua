return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {

    {
      "<leader>fl",
      function()
        local builtins = require("telescope.builtin")

        builtins.find_files({
          find_command = { "fd", "--hidden", "--type", "file" },
          previewer = false,
        })
      end,
      desc = "Fuzzy find files",
    },

    {
      "<leader>fa",
      function()
        local builtins = require("telescope.builtin")

        builtins.find_files({
          find_command = { "fd", "--hidden", "--no-ignore", "--type", "file" },
          previewer = false,
        })
      end,
      desc = "Fuzzy find files (include hidden and ignored)",
    },

    {
      "<leader>fs",
      function()
        require("telescope.builtin").live_grep({
          additional_args = { "--hidden" },
        })
      end,
      desc = "Fuzzy find string (live grep)",
    },

    {
      "<leader>/",
      function()
        require("telescope.builtin").current_buffer_fuzzy_find()
      end,
      desc = "[/] Fuzzily search in current buffer",
    },

    {
      "<leader>xx",
      function()
        require("telescope.builtin").diagnostics()
      end,
      desc = "Fuzzy find diagnostics in workspace",
    },
  },
}
