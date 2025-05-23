return {
  cmd = { "ty", "server" },
  root_markers = {
    ".git", -- Common Git marker
    "pyproject.toml", -- Modern Python packaging standard
    "setup.py", -- Older but common packaging script
    "setup.cfg", -- Configuration for setuptools
    "requirements.txt", -- Common location for dependencies list
    "pyrightconfig.json", -- Pyright's specific configuration file
  },
  filetypes = { "python" },
}
