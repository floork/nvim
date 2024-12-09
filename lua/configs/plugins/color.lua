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

return {
  -- {
  --   "rose-pine/neovim",
  --   config = function()
  --     require("rose-pine").setup({
  --       styles = {
  --         transparency = true,
  --       },
  --     })
  --     -- ColorMyPencil()
  --   end,
  -- },
  -- {
  --   "folke/tokyonight.nvim",
  --   config = function()
  --     require("tokyonight").setup({
  --       -- your configuration comes here
  --       -- or leave it empty to use the default settings
  --       style = "storm",        -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
  --       transparent = true,     -- Enable this to disable setting the background color
  --       terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
  --       styles = {
  --         -- Style to be applied to different syntax groups
  --         -- Value is any valid attr-list value for `:help nvim_set_hl`
  --         comments = { italic = false },
  --         keywords = { italic = false },
  --         -- Background styles. Can be "dark", "transparent" or "normal"
  --         sidebars = "transparent", -- style for sidebars, see below
  --         floats = "transparent",   -- style for floating windows
  --       },
  --     })
  --
  --     -- ColorMyPencil("tokyonight")
  --   end
  -- },
  {
    "ellisonleao/gruvbox.nvim",
    config = function()
      require("gruvbox").setup({
        transparent_mode = true,
      })

      set_colorscheme("gruvbox")
      ColorMyPencil("gruvbox")
    end,
    opts = ...
  }
}
