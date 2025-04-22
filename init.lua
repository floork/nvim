_G.USE_BUILDINS = false
_G.USE_NETRW = false

local function safe_require(mod)
  local ok, module_or_err = pcall(require, mod)
  if not ok then
    vim.notify("Failed to load " .. mod .. ": " .. module_or_err, vim.log.levels.ERROR)
    return nil
  end
  return module_or_err
end

safe_require("configs.core")


if _G.USE_BUILDINS then
  safe_require("configs.core.autocomplete")
  vim.o.syntax = "enable"

  local file_search = safe_require("configs.core.custom.file_open")

  if not file_search or type(file_search.setup) ~= "function" then
    vim.notify("file_search module is invalid or missing setup()", vim.log.levels.WARN)
    return
  end

  file_search.setup({
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
    if file_search.search then
      file_search.search()
    else
      vim.notify("file_search.search() not found", vim.log.levels.ERROR)
    end
  end, { desc = "Find files" })

  vim.keymap.set("n", "<leader>fa", function()
    if file_search.search_with_command then
      file_search.search_with_command("find . -type f")
    else
      vim.notify("file_search.search_with_command() not found", vim.log.levels.ERROR)
    end
  end, { desc = "Find all files" })

  vim.keymap.set('n', '<leader>xx', function()
    local diag = safe_require("configs.core.custom.diagnostic").show_diagnostics()

    if diag == nil then
      return
    end

    diag.show_diagnostics()
  end, {
    noremap = true,
    silent = true,
    desc = 'Show [D]iagnostic [L]ist'
  })

  return
end

safe_require("configs.lazy")
