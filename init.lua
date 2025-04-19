_G.USE_BUILDINS = false
_G.USE_NETRW = false

require("configs.core")

if _G.USE_BUILDINS then
  require("configs.core.autocomplete")
  vim.o.syntax = "enable"
  local file_search = require('configs.core.custom.file_open')
  file_search.setup({
    -- Optional configuration
    -- width = 0.8,
    -- height = 0.8,
    -- prompt_prefix = "> ",
    -- use_fd = false,                                                                     -- Set to true to use fd by default
    -- fd_command = "fd --type f --color never",                                           -- Customize base fd command
    -- find_command = [[find . -type f -not -path '*/\.*' -not -path '*/node_modules/*']], -- Customize base find command
    excludes = {
      ".git",
      "node_modules",
      "target",
      "dist",
      "build",
      ".next",
    },
    include_hidden = false,
  })

  vim.keymap.set("n", "<leader>fl", function()
    file_search.search()
  end, { desc = "Find files" })

  vim.keymap.set("n", "<leader>fa", function()
    file_search.search_with_command("find . -type f")
  end, { desc = "find all files" })

  vim.keymap.set('n', '<leader>xx', function()
    require("configs.core.custom.diagnostic").show_diagnostics()
  end, {
    noremap = true,
    silent = true,
    desc = 'Show [D]iagnostic [L]ist'
  })

  return
end


require("configs.lazy")
