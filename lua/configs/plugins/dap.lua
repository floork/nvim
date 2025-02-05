return {
  'mfussenegger/nvim-dap',
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',
    -- 'mfussenegger/nvim-dap-python',
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

    -- require("dap-python").setup(vim.fn.getcwd() .. "/venv/bin/python")
    -- Utility: Try to find the main entry point for Python
    local function find_main()
      local cwd = vim.fn.getcwd()
      local candidates = {
        cwd .. "/main.py",
        cwd .. "/app.py",
        cwd .. "/src/main.py",
        cwd .. "/src/app.py",
      }
      for _, path in ipairs(candidates) do
        if vim.fn.filereadable(path) == 1 then
          return path
        end
      end
      -- Search subdirectories in ./src
      local src_dir = cwd .. "/src"
      if vim.fn.isdirectory(src_dir) == 1 then
        local dirs = vim.fn.readdir(src_dir)
        for _, dir in ipairs(dirs) do
          local candidate_main = src_dir .. "/" .. dir .. "/main.py"
          local candidate_app  = src_dir .. "/" .. dir .. "/app.py"
          if vim.fn.filereadable(candidate_main) == 1 then
            return candidate_main
          elseif vim.fn.filereadable(candidate_app) == 1 then
            return candidate_app
          end
        end
      end
      return nil
    end

    -- Native Python adapter using debugpy
    dap.adapters.python = {
      type = 'executable',
      command = vim.fn.getcwd() .. '/venv/bin/python', -- adjust if your Python executable is elsewhere
      args = { '-m', 'debugpy.adapter' },
    }
    dap.configurations.python = {
      {
        type = 'python',
        request = 'launch',
        name = "Launch main file",
        program = function()
          local main_file = find_main()
          if main_file then
            return main_file
          else
            return vim.fn.input("Path to main file: ", vim.fn.getcwd() .. "/", "file")
          end
        end,
        pythonPath = function()
          local cwd = vim.fn.getcwd()
          if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
            return cwd .. '/venv/bin/python'
          else
            return 'python'
          end
        end,
      },
      {
        type = 'python',
        request = 'launch',
        name = "Launch file",
        program = "${file}", -- debug the currently open file
        pythonPath = function()
          local cwd = vim.fn.getcwd()
          if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
            return cwd .. '/venv/bin/python'
          else
            return 'python'
          end
        end,
      },
    }
  end,
}
