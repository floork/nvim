_G.USE_BUILDINS = false
_G.USE_NETRW = true

function Safe_require(mod)
  local ok, module_or_err = pcall(require, mod)
  if not ok then
    vim.notify("Failed to load " .. mod .. ": " .. module_or_err, vim.log.levels.ERROR)
    return nil
  end
  return module_or_err
end

vim.log.level = vim.log.levels.INFO

Safe_require("configs.core")
Safe_require("configs.lazy")
Safe_require("configs.core.color")
Safe_require("configs.core.autocomplete")
