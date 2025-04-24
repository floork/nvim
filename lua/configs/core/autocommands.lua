-- [[ Basic Autocommands ]]
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd("BufReadPre", {
  desc = "Autocommand to trigger function when opening a buffer",
  pattern = "*",
  callback = function()
    local shebang = vim.fn.getline(1)
    if shebang:match('^#!.*/bash') then
      vim.bo.filetype = 'sh'
    elseif shebang:match('^#!.*/lua') then
      vim.bo.filetype = 'lua'
    end
  end,
})


local group_cdpwd = vim.api.nvim_create_augroup("group_cdpwd", { clear = true })
vim.api.nvim_create_autocmd("VimEnter", {
  desc = "Set the working directory to the current file's directory",
  group = group_cdpwd,
  pattern = "*",
  callback = function()
    vim.api.nvim_set_current_dir(vim.fn.expand("%:p:h"))
  end,
})
