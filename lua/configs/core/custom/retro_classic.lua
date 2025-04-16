local M = {}

local palette = {
  p0          = "#1c1c1c", -- index 0
  red         = "#d72638", -- index 1
  green       = "#3fb950", -- index 2
  orange      = "#f19d1a", -- index 3
  blue        = "#1e90ff", -- index 4
  purple      = "#a960d2", -- index 5
  cyan        = "#39c5cf", -- index 6
  silver      = "#d3d3d3", -- index 7
  gray        = "#4e4e4e", -- index 8
  pink        = "#ff6e6e", -- index 9
  brightGreen = "#5ffb83", -- index 10
  yellow      = "#ffd966", -- index 11
  lightBlue   = "#87bfff", -- index 12
  lightPurple = "#d68fff", -- index 13
  aqua        = "#73efff", -- index 14
  white       = "#ffffff", -- index 15
}

-- Additional colors (non-palette)
local extra = {
  bg = "#2b2b2b",
  fg = "#e5d27a",
  cursor = "#ffffff",
  cur_text = "#000000",
  sel_bg = "#44475a",
}

-- Define our highlight groups using Neovim's API
local function set_highlights()
  local hl = vim.api.nvim_set_hl

  -- Normal text
  hl(0, "Normal", { fg = extra.fg, bg = extra.bg })

  -- Cursor styling
  hl(0, "Cursor", { fg = extra.cur_text, bg = extra.cursor })

  -- Visual selection
  hl(0, "Visual", { bg = extra.sel_bg })

  -- Comments (using a darker gray from palette index 8)
  hl(0, "Comment", { fg = palette.silver, bg = "NONE", italic = true })

  -- Constants (using retro green from palette index 2)
  hl(0, "Constant", { fg = palette.green, bg = "NONE" })

  -- Identifiers (using bright yellow from palette index 11)
  hl(0, "Identifier", { fg = palette.yellow, bg = "NONE" })

  -- Statements / Keywords (vivid orange from palette index 3)
  hl(0, "Statement", { fg = palette.orange, bg = "NONE", bold = true })

  -- PreProcessor (using retro purple from palette index 5)
  hl(0, "PreProc", { fg = palette.purple, bg = "NONE" })

  -- Types (using a nice blue from palette index 4)
  hl(0, "Type", { fg = palette.blue, bg = "NONE" })

  -- Special characters and operators (using cyan from palette index 6)
  hl(0, "Special", { fg = palette.cyan, bg = "NONE" })

  -- Underlined items (using a soft purple from palette index 13)
  hl(0, "Underlined", { fg = palette.lightPurple, bg = "NONE", underline = true })

  -- Errors (white on a strong red background from palette index 9)
  hl(0, "Error", { fg = palette.white, bg = palette.pink, bold = true })

  -- IncSearch highlight for search matches:
  hl(0, "IncSearch", { fg = palette.white, bg = palette.red, bold = true })

  -- Line numbers
  hl(0, "LineNr", { fg = palette.gray, bg = extra.bg })

  -- Cursor line and column for better orientation
  hl(0, "CursorLine", { bg = palette.p0 })
  hl(0, "CursorColumn", { bg = palette.p0 })

  -- Matching parentheses: white text on retro green
  hl(0, "MatchParen", { fg = palette.white, bg = palette.green, bold = true })

  -- StatusLine (mirroring your tmux segments)
  hl(0, "StatusLine", { fg = palette.yellow, bg = extra.bg, bold = true })
  hl(0, "StatusLineNC", { fg = palette.silver, bg = extra.bg })

  -- Popup menu for completion
  hl(0, "Pmenu", { fg = extra.fg, bg = palette.p0 })
  hl(0, "PmenuSel", { fg = extra.fg, bg = palette.green })
end

function M.setup()
  set_highlights()
end

return M
