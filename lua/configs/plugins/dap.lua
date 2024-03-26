-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

return {
  'mfussenegger/nvim-dap',
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',

    -- Required dependency for nvim-dap-ui
    'nvim-neotest/nvim-nio',
    'theHamsta/nvim-dap-virtual-text',

    -- Installs the debug adapters for you
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Add your own debuggers here
    'leoluz/nvim-dap-go', -- go
    {
      'mfussenegger/nvim-dap-python',
      dependencies = { 'microsoft/debugpy' },
    },
    'google/cppdap', -- cpp
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_setup = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
      },
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

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup {
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    }

    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    vim.keymap.set('n', '<F7>', dapui.toggle, { desc = 'Debug: See last session result.' })

    dapui.setup()
    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open({})
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close({})
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close({})
    end

    dap.adapters.gdb = {
      type = "executable",
      command = "gdb",
      args = { "-i", "dap" }
    }

    dap.configurations.cpp = {
      {
        name = "Build with CMake and Launch",
        type = "gdb",
        request = "launch",
        program = function()
          if vim.fn.isdirectory('build') == 0 then
            vim.api.nvim_command('!cmake -B build')
          end
          vim.api.nvim_command('!cmake --build build')

          local executable_path = vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          return executable_path
        end,
        cwd = "${workspaceFolder}",
        stopAtBeginningOfMainSubprogram = false,
      },
      {
        name = "Launch",
        type = "gdb",
        request = "launch",
        program = function()
          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = "${workspaceFolder}",
        stopAtBeginningOfMainSubprogram = false,
      },
    }

    dap.configurations.c = dap.configurations.cpp
    dap.configurations.rust = {
      {
        name = "Launch",
        type = "gdb",
        request = "launch",
        program = function()
          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = "${workspaceFolder}",
        stopAtBeginningOfMainSubprogram = false,
      },
    }

    -- Install golang specific config
    require('dap-go').setup()

    -- Install python specific config
    require("dap-python").setup()
  end,
}
