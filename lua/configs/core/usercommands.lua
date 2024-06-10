vim.api.nvim_create_user_command(
  "W",
  function()
    vim.cmd("wa")
  end,
  { nargs = 0, desc = "Save all files" }
)
