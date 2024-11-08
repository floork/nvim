vim.api.nvim_create_user_command(
  "W",
  function()
    vim.cmd("wa")
  end,
  { nargs = 0, desc = "Save all files" }
)

vim.api.nvim_create_user_command(
  "Wa",
  function()
    vim.cmd("wa")
  end,
  { nargs = 0, desc = "Save all files" }
)

vim.api.nvim_create_user_command(
  "E",
  function()
    vim.cmd("e!")
  end,
  { nargs = 0, desc = "Save all files" }
)
