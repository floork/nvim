require("configs.core.keymaps")
require("configs.core.options")
require("configs.core.autocommands")
require("configs.core.usercommands")
require("configs.core.netrw")
require("configs.core.custom")
require("configs.core.color")
require("configs.core.lsp")

vim.filetype.add({
  filename = {
    ["gitconfig"] = ".gitconfig",
    ["DOCKERFILE"] = "dockerfile",
  },
})
