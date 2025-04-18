return {
  cmd = {
    'gopls',
  },
  filetypes = { "go", "gomod" },
  root_markers = { "go.work", "go.mod", ".git" },
  settings = {
    experimentalPostfixCompletions = true,
    analyses = {
      unusedparams = true,
      shadow = true,
    },
    staticcheck = true,
  }
}
