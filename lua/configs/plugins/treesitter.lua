return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPre", "BufNewFile" },
  build = ":TSUpdate",
  dependencies = {
    "windwp/nvim-ts-autotag",
    { "nushell/tree-sitter-nu" },
  },
  config = function()
    local treesitter = require("nvim-treesitter.configs")

    ---@class ParserInfo
    local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

    ---@class parser_config.nu : ParserInfo
    parser_config.nu = {
      install_info = {
        url = "https://github.com/nushell/tree-sitter-nu",
        files = { "src/parser.c" },
        branch = "main",
      },
      filetype = "nu",
    }

    treesitter.setup({
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = { enable = true },
      autotag = {
        enable = true,
      },
      ensure_installed = {
        "json",
        "javascript",
        "typescript",
        "tsx",
        "yaml",
        "html",
        "css",
        "prisma",
        "markdown",
        "markdown_inline",
        "nu",
        "svelte",
        "graphql",
        "bash",
        "lua",
        "vim",
        "dockerfile",
        "gitignore",
        "cpp",
        "rust",
        "toml",
        "python",
      },
      auto_install = true,
      sync_install = false,
      ignore_install = {},
      modules = {},
    })
  end,
}
