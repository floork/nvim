return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPre", "BufNewFile" },
  build = ":TSUpdate",
  config = function()
    local treesitter = require("nvim-treesitter.configs")

    ---@class ParserInfo
    local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

    treesitter.setup({
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = { enable = false },
      autotag = {
        enable = true,
      },
      ensure_installed = {
        "json",
        "javascript",
        "yaml",
        "html",
        "css",
        "markdown",
        "markdown_inline",
        "bash",
        "lua",
        "vim",
        "dockerfile",
        "gitignore",
        "gitcommit",
        "cpp",
        "rust",
        "toml",
        "python",
      },
      auto_install = true,
      sync_install = true,
      ignore_install = {},
      modules = {},
    })
  end,
}
