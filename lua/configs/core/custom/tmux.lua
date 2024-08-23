-- Function to check if a split exists in the given direction, otherwise move to tmux
function _G.navigate(direction)
  local win = vim.fn.winnr()
  vim.cmd('wincmd ' .. direction)
  if win == vim.fn.winnr() then
    -- No split in the direction, so send the command to tmux
    if direction == 'h' then
      vim.fn.system('tmux select-pane -L')
    elseif direction == 'j' then
      vim.fn.system('tmux select-pane -D')
    elseif direction == 'k' then
      vim.fn.system('tmux select-pane -U')
    elseif direction == 'l' then
      vim.fn.system('tmux select-pane -R')
    end
  end
end

-- Key mappings
local keymap = vim.keymap
local opts = { noremap = true, silent = true }

opts.desc = "Navigate left in nvim or tmux"
keymap.set('n', '<C-h>', ':lua navigate("h")<CR>', opts)

opts.desc = "Navigate down in nvim or tmux"
keymap.set('n', '<C-j>', ':lua navigate("j")<CR>', opts)

opts.desc = "Navigate up in nvim or tmux"
keymap.set('n', '<C-k>', ':lua navigate("k")<CR>', opts)

opts.desc = "Navigate left in nvim or tmux"
keymap.set('n', '<C-l>', ':lua navigate("l")<CR>', opts)
