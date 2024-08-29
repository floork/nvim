return {
  "folke/trouble.nvim",
  keys = {
    {
      "<leader>xx",
      function()
        require("trouble").toggle("diagnostics")
      end,
      desc = "Toggle trouble"
    },
  },
  config = true,
}
