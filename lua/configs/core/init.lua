require("configs.core.keymaps")
require("configs.core.options")
require("configs.core.autocommands")
require("configs.core.usercommands")
require("configs.core.custom")

-- netrw
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 15
vim.g.netrw_liststyle = 3
vim.g.netrw_browse_split = 0
vim.g.netrw_list_depth = 999

vim.filetype.add({
  filename = {
    ["gitconfig"] = ".gitconfig",
    ["DOCKERFILE"] = "dockerfile",
  },
})
