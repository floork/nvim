local opt = vim.opt

-- Cursor
opt.guicursor = ""

-- Line Numbers
opt.relativenumber = true
opt.number = true

-- Indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true
opt.smartindent = true

-- Display
opt.list = true
opt.listchars:append({ tab = "␉ ", trail = "·" })
opt.wrap = false

-- Search
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
opt.undofile = true
opt.updatetime = 50
opt.scrolloff = 8

-- Spellcheck
opt.spelllang = "en_us"
opt.spell = true

-- Folding
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldlevel = 9999

-- Clipboard
opt.clipboard:append("unnamedplus") -- use system clipboard as default register
