return {
  "Exafunction/codeium.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "hrsh7th/nvim-cmp",
  },
  config = function()
    local codeium = require("codeium")
    codeium.setup({
      virtual_text = {
        enabled = true
      }
    })
  end
}
