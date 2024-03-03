-- Set leader key to space
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Define a local variable for keymap utility
local keymap = vim.keymap

-- Text operations
keymap.set("n", "x", '"_x', { desc = "Delete without yanking", noremap = true, silent = true })

keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down", noremap = true, silent = true })
keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up", noremap = true, silent = true })

keymap.set("x", "<C-t>", ">gv", { desc = "Indent right", noremap = true, silent = true })
keymap.set("x", "<C-d>", "<gv", { desc = "Indent left", noremap = true, silent = true })

-- Search and replace
keymap.set(
  "n",
  "<leader>s",
  [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = "Search and replace", noremap = true, silent = true }
)

-- Join lines without moving cursor
keymap.set("n", "J", "mzJ`z", { desc = "Join lines without moving cursor", noremap = true, silent = true })

-- Split lines without moving cursor
keymap.set(
  "n",
  "K",
  [[:s/\v(%#\_.{-})/\1\r]],
  { desc = "Split lines without moving cursor", noremap = true, silent = true }
)

-- Toggle file explorer
keymap.set("n", "<leader>ee", vim.cmd.Ex, { desc = "Toggle file explorer", noremap = true, silent = true })
