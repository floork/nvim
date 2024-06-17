return {
  "numToStr/Comment.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local comment = require("Comment")

    -- enable comment
    comment.setup({
      toggle = true,
      opleader = {
        line = "gcc",
        block = "gcb",
      },
    })
  end,
}
