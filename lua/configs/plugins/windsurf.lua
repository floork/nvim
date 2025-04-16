return {
  "Exafunction/windsurf.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    require("codeium").setup({
      enable_cmp_source = false,
      virtual_text = {
        enabled = true,
        key_bindings = {
          accept = "<S-Tab>",
          accept_word = false,
          accept_line = false,
          next = "<C-n>",
          prev = "<C-p>",
          dismiss = "<C-e>",
        }
      }
    })


    vim.api.nvim_create_user_command(
      "CodeiumDisable",
      function() require("codeium.config").options.virtual_text.manual = true end,
      { nargs = 0, desc = "Disable Codeium virtual text" }
    )

    vim.api.nvim_create_user_command(
      "CodeiumEnable",
      function() require("codeium.config").options.virtual_text.manual = false end,
      { nargs = 0, desc = "Enable Codeium virtual text" }
    )

    vim.api.nvim_create_user_command(
      "CodeiumToggle",
      function()
        local virtual_text = require("codeium.config").options.virtual_text
        virtual_text.manual = not virtual_text.manual
      end,
      { nargs = 0, desc = "Toggle Codeium virtual text" }
    )
  end
}
