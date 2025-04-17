return {
  {
    cmd = { "html-lsp" },
    filetypes = { "html" },
  },
  {
    cmd = { "typescript-language-server" },
    filetypes = { "typescript", "typescriptreact" },
    settings = {
      init_options = {
        plugins = {
          {
            name = '@vue/typescript-plugin',
            languages = { 'vue' },
          },
        },
      },
    }
  },
  {
    cmd = { "vue-language-server" },
    filetypes = { "vue" },
    settings = {
      init_options = {
        vue = {
          hybridMode = false,
        },
      },
    }
  },
}
