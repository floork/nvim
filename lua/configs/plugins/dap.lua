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

        dap.defaults.cpp.external_terminal = {
          command = "wezterm",
          args = { "-e" },
        }

        -- keymaps
        local keymap = vim.keymap
        local options = {
          noremap = true,
          silent = true,
        }
        options.desc = "Toggle DAP UI"
        keymap.set("n", "<leader>du", "<cmd>lua require('dapui').toggle()<CR>", options)
        options.desc = "Evaluate DAP expressions"
        keymap.set("n", "<leader>de", "<cmd>lua require('dapui').eval()<CR>", options)
        options.desc = "Toggle breakpoint"
        keymap.set("n", "<leader>dp", "<cmd>lua require('dap').toggle_breakpoint()<CR>", options)
        options.desc = "Continue execution"
        keymap.set("n", "<leader>dc", "<cmd>lua require('dap').continue()<CR>", options)
        options.desc = "Step into"
        keymap.set("n", "<leader>di", "<cmd>lua require('dap').step_into()<CR>", options)
        options.desc = "Step over"
        keymap.set("n", "<leader>do", "<cmd>lua require('dap').step_over()<CR>", options)
        options.desc = "Step out"
        keymap.set("n", "<leader>dO", "<cmd>lua require('dap').step_out()<CR>", options)
        options.desc = "Pause execution"
        keymap.set("n", "<leader>dP", "<cmd>lua require('dap').pause()<CR>", options)
        options.desc = "Terminate DAP session"
        keymap.set("n", "<leader>dt", "<cmd>lua require('dap').terminate()<CR>", options)
        options.desc = "Re-run last DAP configuration"
        keymap.set("n", "<leader>dr", "<cmd>lua require('dap').run_last()<CR>", options)
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
