return {
  'mfussenegger/nvim-dap',
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',
  },
  keys = {
    { "<leader>du", "<cmd>lua require('dapui').toggle()<CR>",          desc = "Toggle DAP UI" },
    { "<leader>de", "<cmd>lua require('dapui').eval()<CR>",            desc = "Evaluate DAP expressions" },
    { "<leader>dp", "<cmd>lua require('dap').toggle_breakpoint()<CR>", desc = "Toggle breakpoint" },
    { "<leader>dc", "<cmd>lua require('dap').continue()<CR>",          desc = "Continue execution" },
    { "<leader>di", "<cmd>lua require('dap').step_into()<CR>",         desc = "Step into" },
    { "<leader>do", "<cmd>lua require('dap').step_over()<CR>",         desc = "Step over" },
    { "<leader>dO", "<cmd>lua require('dap').step_out()<CR>",          desc = "Step out" },
    { "<leader>dP", "<cmd>lua require('dap').pause()<CR>",             desc = "Pause execution" },
    { "<leader>dt", "<cmd>lua require('dap').terminate()<CR>",         desc = "Terminate DAP session" },
  },
  config = function()
    local dap = require('dap')

    local dapui = require("dapui")
    dapui.setup {
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
    dap.configurations.c = {
      {
        name = "Launch",
        type = "gdb",
        request = "launch",
        program = function()
          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = "${workspaceFolder}",
        stopAtBeginningOfMainSubprogram = false,
        args = function()
          local args_string = vim.fn.input('Arguments: ')
          -- Expand the tilde (~) to the home directory
          args_string = string.gsub(args_string, "^~", vim.fn.expand("$HOME"))
          return vim.split(args_string, " ")
        end,
      },
    }

    dap.configurations.cpp = dap.configurations.c
    dap.configurations.rust = dap.configurations.c
  end,
}
