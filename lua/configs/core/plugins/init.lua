Safe_require("configs.core.plugins.tmux_nav").setup()

local format = Safe_require("configs.core.plugins.format")
if not format then
  vim.notify("Failed to load configs.core.plugins.formatting", vim.log.levels.ERROR)
  return
end

format.setup({
  formatters_by_ft = {
    bash = { "shfmt" }, -- Bash formatter (shfmt)
    sh = { "shfmt" }, -- Shell formatter (shfmt)
    zsh = { "shfmt" }, -- Zsh formatter (shfmt)
    c = { "my_cpp" }, -- C formatter (clang-format)
    cpp = { "my_cpp" }, -- C++ formatter (clang-format)
    css = { "prettier" }, -- CSS formatter (prettier)
    go = { "gofmt" }, -- Go formatter (gofmt)
    html = { "prettier" }, -- HTML formatter (prettier)
    javascript = { "prettier" }, -- JavaScript formatter (prettier)
    json = { "prettier" }, -- JSON formatter (prettier)
    lua = { { command = "stylua", args = { "--indent-width", "2", "--indent-type", "Spaces" }, requires_file = true } }, -- Lua formatter (stylua)
    markdown = { "prettier" }, -- Markdown formatter (prettier)
    nix = { "nixfmt" }, -- Nix formatter (nixfmt)
    python = { "isort", "black" }, -- Python formatters (isort, black)
    rust = { "rust_analyzer" }, -- Rust formatter (rustfmt)
    tex = { "tex_fmt" }, -- LaTeX formatter (tex-fmt)
    toml = { "taplo" }, -- TOML formatter (prettier)
    yml = { "prettier" }, -- YAML formatter (prettier)
  },
  format_on_save = true, -- or provide a function(bufnr) returning opts
})

vim.keymap.set({ "n", "v" }, "<leader>mf", function()
  format.format({
    lsp_fallback = true,
    async = false,
    override_disabled = true, -- ignore FormatDisable
  })
end, { desc = "Format buffer or range" })

if _G.USE_BUILDINS then
  vim.keymap.set("n", "<leader>xx", function()
    local diag = Safe_require("configs.core.plugins.diagnostic").show_diagnostics()

    if diag == nil then
      return
    end

    diag.show_diagnostics()
  end, {
    noremap = true,
    silent = true,
    desc = "Show [D]iagnostic [L]ist",
  })

  return
end
