_G.USE_BUILDINS = false
_G.USE_NETRW = false

require("configs.core")


vim.keymap.set("n", "<leader>t",
  function()
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
    file_search.search()
  end
  , { noremap = true, silent = true })
if _G.USE_BUILDINS then
  require("configs.core.autocomplete")
  vim.o.syntax = "enable"


  vim.keymap.set("n", "<leader>t", ":FileSearch<CR>", { noremap = true, silent = true })
  return
end


require("configs.lazy")
