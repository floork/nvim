return {
  "floork/term.nvim",
  config = function()
    require("term").setup({
      toggle_terminal_key = "<C-t>"
    })
  end
}
