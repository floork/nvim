return {
  "mfussenegger/nvim-dap",

  dependencies = {

    -- fancy UI for the debugger
    {
      "rcarriga/nvim-dap-ui",
      opts = {},
      config = function(_, opts)
        -- setup dap config by VsCode launch.json file
        -- require("dap.ext.vscode").load_launchjs()
        local dap = require("dap")
        local dapui = require("dapui")
        dapui.setup(opts)
        dap.listeners.after.event_initialized["dapui_config"] = function()
          dapui.open({})
        end
        dap.listeners.before.event_terminated["dapui_config"] = function()
          dapui.close({})
        end
        dap.listeners.before.event_exited["dapui_config"] = function()
          dapui.close({})
        end
        local keymap = vim.keymap
        local opts = { noremap = true, silent = true }
        keymap.set("n", "<leader>bu", "<cmd>lua require('dapui').toggle()<CR>", opts)
        keymap.set("n", "<leader>be", "<cmd>lua require('dapui').eval()<CR>", opts)
        keymap.set("n", "<leader>bp", "<cmd>lua require('dap').toggle_breakpoint()<CR>", opts)
        keymap.set("n", "<leader>bc", "<cmd>lua require('dap').continue()<CR>", opts)
        keymap.set("n", "<leader>bi", "<cmd>lua require('dap').step_into()<CR>", opts)
        keymap.set("n", "<leader>bo", "<cmd>lua require('dap').step_over()<CR>", opts)
        keymap.set("n", "<leader>bO", "<cmd>lua require('dap').step_out()<CR>", opts)
        keymap.set("n", "<leader>bP", "<cmd>lua require('dap').pause()<CR>", opts)
        keymap.set("n", "<leader>bt", "<cmd>lua require('dap').terminate()<CR>", opts)
        keymap.set("n", "<leader>br", "<cmd>lua require('dap').run_last()<CR>", opts)
      end,
    },

    -- virtual text for the debugger
    {
      "theHamsta/nvim-dap-virtual-text",
      opts = {
        enabled = true,
        enabled_commands = true,
      },
    },

    -- mason.nvim integration
    {
      "jay-babu/mason-nvim-dap.nvim",
      dependencies = "mason.nvim",
      cmd = { "DapInstall", "DapUninstall" },
      opts = {
        -- Makes a best effort to setup the various debuggers with
        -- reasonable debug configurations
        automatic_installation = true,

        -- You can provide additional configuration to the handlers,
        -- see mason-nvim-dap README for more information
        handlers = {},

        -- You'll need to check that you have the required things installed
        -- online, please don't ask me how to install them :)
        ensure_installed = {
          -- Update this to ensure that you have the debuggers for the langs you want
        },
      },
    },
  },
}
