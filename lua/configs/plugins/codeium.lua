return {
  "Exafunction/codeium.vim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "hrsh7th/nvim-cmp",
  },
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    vim.g.codeium_enabled = false
  end
}
