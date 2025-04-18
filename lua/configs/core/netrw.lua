if not _G.USE_BUILDINS then
  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1
  return
end

-- netrw
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 15
vim.g.netrw_liststyle = 3
vim.g.netrw_browse_split = 0
vim.g.netrw_list_depth = 999

vim.api.nvim_create_autocmd("FileType", {
  pattern = "netrw",
  callback = function()
    -- Unmap Ctrl+l
    vim.keymap.set("n", "<C-l>", '<Cmd>lua navigate("l")<CR>', { buffer = true })

    -- Remap Ctrl+r to reload the netrw directory view
    vim.keymap.set("n", "<C-r>", "<Plug>NetrwRefresh", { buffer = true, silent = true })
  end,
})
