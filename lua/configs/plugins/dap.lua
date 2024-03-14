return {
  "mfussenegger/nvim-dap",

  dependencies = {

    -- fancy UI for the debugger
    {
      "rcarriga/nvim-dap-ui",
      dependencies = { "mxsdev/nvim-dap-vscode-js" },
      opts = {},
      config = function(_, opts)
        -- setup dap config by VsCode launch.json file
        -- require("dap.ext.vscode").load_launchjs()
        local dap = require("dap")
        local dapui = require("dapui")
        local _, dap_utils = pcall(require, "dap.utils")

        -- VSCODE JS (Node/Chrome/Terminal/Jest)
        require("dap-vscode-js").setup({
          debugger_path = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter",
          debugger_cmd = { "js-debug-adapter" },
          adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
        })

        local exts = {
          "javascript",
          "typescript",
          "javascriptreact",
          "typescriptreact",
          "vue",
          "svelte",
        }

        for i, ext in ipairs(exts) do
          dap.configurations[ext] = {
            {
              type = "pwa-chrome",
              request = "launch",
              name = "Launch Chrome with \"localhost\"",
              url = function()
                local co = coroutine.running()
                return coroutine.create(function()
                  vim.ui.input({ prompt = 'Enter URL: ', default = 'http://localhost:3000' }, function(url)
                    if url == nil or url == '' then
                      return
                    else
                      coroutine.resume(co, url)
                    end
                  end)
                end)
              end,
              webRoot = vim.fn.getcwd(),
              protocol = 'inspector',
              sourceMaps = true,
              userDataDir = false,
              resolveSourceMapLocations = {
                "${workspaceFolder}/**",
                "!**/node_modules/**",
              }
            },
            {
              type = "pwa-node",
              request = "launch",
              name = "Launch Current File (pwa-node)",
              cwd = vim.fn.getcwd(),
              args = { "${file}" },
              sourceMaps = true,
              protocol = "inspector",
              runtimeExecutable = "npm",
              runtimeArgs = {
                "run-script", "dev"
              },
              resolveSourceMapLocations = {
                "${workspaceFolder}/**",
                "!**/node_modules/**",
              }

            },
            {
              type = "pwa-node",
              request = "launch",
              name = "Launch Current File (pwa-node with ts-node)",
              cwd = vim.fn.getcwd(),
              runtimeArgs = { "--loader", "ts-node/esm" },
              runtimeExecutable = "node",
              args = { "${file}" },
              sourceMaps = true,
              protocol = "inspector",
              skipFiles = { "<node_internals>/**", "node_modules/**" },
              resolveSourceMapLocations = {
                "${workspaceFolder}/**",
                "!**/node_modules/**",
              },
            },
            {
              type = "pwa-node",
              request = "launch",
              name = "Launch Current File (pwa-node with deno)",
              cwd = vim.fn.getcwd(),
              runtimeArgs = { "run", "--inspect-brk", "--allow-all", "${file}" },
              runtimeExecutable = "deno",
              attachSimplePort = 9229,
            },
            {
              type = "pwa-node",
              request = "launch",
              name = "Launch Test Current File (pwa-node with jest)",
              cwd = vim.fn.getcwd(),
              runtimeArgs = { "${workspaceFolder}/node_modules/.bin/jest" },
              runtimeExecutable = "node",
              args = { "${file}", "--coverage", "false" },
              rootPath = "${workspaceFolder}",
              sourceMaps = true,
              console = "integratedTerminal",
              internalConsoleOptions = "neverOpen",
              skipFiles = { "<node_internals>/**", "node_modules/**" },
            },
            {
              type = "pwa-node",
              request = "launch",
              name = "Launch Test Current File (pwa-node with vitest)",
              cwd = vim.fn.getcwd(),
              program = "${workspaceFolder}/node_modules/vitest/vitest.mjs",
              args = { "--inspect-brk", "--threads", "false", "run", "${file}" },
              autoAttachChildProcesses = true,
              smartStep = true,
              console = "integratedTerminal",
              skipFiles = { "<node_internals>/**", "node_modules/**" },
            },
            {
              type = "pwa-node",
              request = "launch",
              name = "Launch Test Current File (pwa-node with deno)",
              cwd = vim.fn.getcwd(),
              runtimeArgs = { "test", "--inspect-brk", "--allow-all", "${file}" },
              runtimeExecutable = "deno",
              attachSimplePort = 9229,
            },
            {
              type = "pwa-chrome",
              request = "attach",
              name = "Attach Program (pwa-chrome, select port)",
              program = "${file}",
              cwd = vim.fn.getcwd(),
              sourceMaps = true,
              protocol = 'inspector',
              port = function()
                return vim.fn.input("Select port: ", 9222)
              end,
              webRoot = "${workspaceFolder}",
            },
            {
              type = "pwa-node",
              request = "attach",
              name = "Attach Program (pwa-node, select pid)",
              cwd = vim.fn.getcwd(),
              processId = dap_utils.pick_process,
              skipFiles = { "<node_internals>/**" },
            },
          }
        end

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
