return {
  cmd = { "rust-analyzer" },
  filetypes = { "rust" },
  settings = {
    imports = {
      granularity = {
        group = "module",
      },
      prefix = "self",
    },
    cargo = {
      checkOnSave = {
        command = "clippy",
      },
      buildScripts = {
        enable = true,
      },
    },
    procMacro = {
      enable = true
    },
    inlayHints = {
      enable = true,
      showParameterNames = true,
      parameterHintsPrefix = "<- ",
      otherHintsPrefix = "=> ",
    },
  },
}
