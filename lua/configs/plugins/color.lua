local function set_colorscheme(name)
  vim.cmd("colorscheme " .. name)
end

function ColorMyPencil(color)
  color = color or "rose-pine"
  vim.cmd.colorscheme(color)

  vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
  vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
  vim.api.nvim_set_hl(0, "DiffChange", { bg = "none" })
  vim.api.nvim_set_hl(0, "ColorColumn", { bg = "#3c3836" })
end

local function set_rose_pine()
  return {
    "rose-pine/neovim",
    config = function()
      require("rose-pine").setup({
        styles = {
          transparency = true,
        },
      })
    end,
  }
end

local function set_tokyonight()
  return {
    "folke/tokyonight.nvim",
    config = function()
      require("tokyonight").setup({
        -- your configuration comes here
        -- or leave it empty to use the default settings
        style = "storm",        -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
        transparent = true,     -- Enable this to disable setting the background color
        terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
        styles = {
          -- Style to be applied to different syntax groups
          -- Value is any valid attr-list value for `:help nvim_set_hl`
          comments = { italic = false },
          keywords = { italic = false },
          -- Background styles. Can be "dark", "transparent" or "normal"
          sidebars = "transparent", -- style for sidebars, see below
          floats = "transparent",   -- style for floating windows
        },
      })
    end
  }
end

local function set_gruvbox()
  return {
    "ellisonleao/gruvbox.nvim",
    config = function()
      require("gruvbox").setup({
        transparent_mode = true,
      })
    end,
  }
end

local function set_color(color)
  set_colorscheme(color)
  ColorMyPencil(color)

  if color == "rose-pine" then
    return set_rose_pine()
  end

  if color == "tokyonight" then
    return set_tokyonight()
  end

  if color == "gruvbox" then
    return set_gruvbox()
  end

  return {}
end


return set_color("retrobox")
