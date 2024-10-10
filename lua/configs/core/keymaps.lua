-- Set leader key to space
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Define a local variable for keymap utility
local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- Text operations
opts.desc = "Delete without yanking single char"
keymap.set("n", "x", '"_x', opts)
opts.desc = "Delete without yanking selected"
keymap.set("v", "d", '"_x', opts)
opts.desc = "Delete without yanking to end of line"
keymap.set("n", "D", '"_D', opts)
opts.desc = "Normal pasting"
keymap.set("i", "<C-v>", '<C-r>+', opts)

-- Search and replace
opts.desc = "Search and replace"
keymap.set(
  "n",
  "<leader>s",
  [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  opts
)

-- Move Lines UP and DOWN
opts.desc = "Move line down"
keymap.set("v", "J", ":m '>+1<CR>gv=gv", opts)
opts.desc = "Move line up"
keymap.set("v", "K", ":m '<-2<CR>gv=gv", opts)

-- Join lines without moving cursor
opts.desc = "Join lines without moving cursor"
keymap.set("n", "J", "mzJ`z", opts)
opts.desc = "Split lines at cursor"
keymap.set("n", "U", "i<Enter><Esc>", opts)

-- Toggle file explorer
opts.desc = "Toggle file explorer"
keymap.set("n", "<leader>ee", vim.cmd.Ex, opts)

-- Readjust the Window size
opts.desc = "Readjust the window size"
keymap.set("n", "<leader>ww", "<cmd>wincmd =<CR>", opts)
