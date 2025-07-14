local opt = vim.opt

-- Cursor
opt.guicursor = ""

-- Line Numbers
opt.relativenumber = true
opt.number = true

opt.mouse = "a"

-- Indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true
opt.smartindent = true

opt.list = true
opt.listchars = {
  eol = "$",
  extends = ">",
  nbsp = "␣",
  precedes = "<",
  space = "·",
  tab = "» ",
  trail = "·",
}
opt.wrap = false
opt.timeoutlen = 1000
opt.inccommand = "split"
opt.cursorline = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false
opt.incsearch = true

-- Appearance
opt.termguicolors = true
opt.signcolumn = "yes"
opt.colorcolumn = "80"

-- Behavior
opt.backspace = "indent,eol,start"
opt.splitright = true
opt.splitbelow = true
opt.swapfile = false
opt.backup = false
opt.writebackup = false
opt.undofile = true
opt.undodir = vim.fn.expand("~/.vim/undodir")
opt.updatetime = 50
opt.scrolloff = 8
opt.autoread = true
opt.autowrite = false
opt.hidden = true
opt.errorbells = false
vim.opt.autochdir = false
vim.opt.iskeyword:append("-")
vim.opt.modifiable = true
vim.opt.encoding = "UTF-8"

-- Spellcheck
opt.spelllang = { "en", "de" }
opt.spell = true

-- Folding
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldlevel = 9999

-- find
opt.path:append("**")
opt.wildmenu = true
opt.wildmode = { "longest:full", "full" }

-- Clipboard
opt.clipboard:append("unnamedplus") -- use system clipboard as default register
