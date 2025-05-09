local M = {}

-- Core navigation function
function M.navigate(direction)
  local win = vim.fn.winnr()
  vim.cmd('wincmd ' .. direction)
  if win == vim.fn.winnr() then
    local tmux_cmds = {
      h = "tmux select-pane -L",
      j = "tmux select-pane -D",
      k = "tmux select-pane -U",
      l = "tmux select-pane -R",
    }
    local cmd = tmux_cmds[direction]
    if cmd then
      vim.fn.system(cmd)
    end
  end
end

-- Setup function to map keys
function M.setup()
  local opts = { noremap = true, silent = true }

  vim.keymap.set('n', '<C-h>', function() M.navigate("h") end, vim.tbl_extend("force", opts, { desc = "Navigate left" }))
  vim.keymap.set('n', '<C-j>', function() M.navigate("j") end, vim.tbl_extend("force", opts, { desc = "Navigate down" }))
  vim.keymap.set('n', '<C-k>', function() M.navigate("k") end, vim.tbl_extend("force", opts, { desc = "Navigate up" }))
  vim.keymap.set('n', '<C-l>', function() M.navigate("l") end, vim.tbl_extend("force", opts, { desc = "Navigate right" }))
end

return M
