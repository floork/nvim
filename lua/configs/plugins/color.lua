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

-- Configuration for rose-pine theme.
local function set_rose_pine()
  return {
    "rose-pine/neovim",
    config = function()
      require("rose-pine").setup({
        styles = { transparency = true },
      })
      apply_theme("rose-pine")
    end,
  }
end

-- Configuration for tokyonight theme.
local function set_tokyonight()
  return {
    "folke/tokyonight.nvim",
    config = function()
      require("tokyonight").setup({
        style = "storm",
        transparent = true,
        terminal_colors = true,
        styles = {
          comments = { italic = false },
          keywords = { italic = false },
          sidebars = "transparent",
          floats = "transparent",
        },
      })
      apply_theme("tokyonight")
    end,
  }
end

-- Configuration for gruvbox theme.
local function set_gruvbox()
  return {
    "ellisonleao/gruvbox.nvim",
    config = function()
      require("gruvbox").setup({
        transparent_mode = true,
      })
      apply_theme("gruvbox")
    end,
  }
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

return set_color("retrobox")
