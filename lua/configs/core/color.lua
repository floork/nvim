local function set_colorscheme(name)
  vim.cmd("colorscheme " .. name)
end

local function set_highlights()
  local groups = { "Normal", "NormalFloat", "SignColumn", "DiffChange", "WinSeparator" }
  for _, group in ipairs(groups) do
    vim.api.nvim_set_hl(0, group, { bg = "none" })
  end
  vim.api.nvim_set_hl(0, "ColorColumn", { bg = "#3c3836" })
end

local function apply_theme(color)
  set_colorscheme(color)
  set_highlights()
end

-- Configuration for classic_retro theme.
local function set_classic_retro()
  require("configs.core.custom.retro_classic").setup()
  set_highlights()
end

-- Main function to choose and apply the desired color scheme.
local function set_color(color)
  local out = {}
  if color == "rose-pine" then
    out = set_rose_pine()
  elseif color == "tokyonight" then
    out = set_tokyonight()
  elseif color == "gruvbox" then
    out = set_gruvbox()
  elseif color == "classic_retro" then
    out = set_classic_retro()
    return {}
  else
    apply_theme(color)
  end

  if color == "retrobox" then
    vim.api.nvim_set_hl(0, "NeogitDiffAdd", {
      fg = "#000000",
      bg = "#A9DC76" -- bright green
    })
    vim.api.nvim_set_hl(0, "NeogitDiffAddHighlight", {
      fg = "#000000",
      bg = "#A9DC76" -- bright green
    })
    vim.api.nvim_set_hl(0, "NeogitDiffDeletions", {
      fg = "#000000",
      bg = "#CC6666" -- bright red
    })
    vim.api.nvim_set_hl(0, "NeogitDiffDeleteCursor", {
      fg = "#000000",
      bg = "#CC6666" -- bright red
    })
  end

  return out
end

return set_color("classic_retro")
