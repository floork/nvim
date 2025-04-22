local modules = {
  "configs.core.custom.build",
  "configs.core.custom.tmux",
  "configs.core.custom.file_open"
}

for _, mod in ipairs(modules) do
  local ok, err = pcall(require, mod)
  if not ok then
    vim.notify("Failed to load " .. mod .. ": " .. err, vim.log.levels.ERROR)
  end
end
