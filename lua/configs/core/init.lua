local modules = {
  "configs.core.keymaps",
  "configs.core.options",
  "configs.core.autocommands",
  "configs.core.usercommands",
  "configs.core.netrw",
  "configs.core.lsp",
  "configs.core.plugins"
}

for _, mod in ipairs(modules) do
  local ok, err = pcall(require, mod)
  if not ok then
    vim.notify("Failed to load " .. mod .. ": " .. err, vim.log.levels.ERROR)
  end
end

vim.filetype.add({
  filename = {
    ["gitconfig"] = ".gitconfig",
    ["DOCKERFILE"] = "dockerfile",
  },
  pattern = {
    ["%.tex$"] = "tex",
  },
})

vim.g.tex_flavor = "latex"

if _G.USE_BUILDINS then
  vim.o.syntax = "enable"
end
