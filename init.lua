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
