_G.USE_BUILDINS = false
_G.USE_NETRW = false

local function safe_require(mod)
  local ok, module_or_err = pcall(require, mod)
  if not ok then
    vim.notify("Failed to load " .. mod .. ": " .. module_or_err, vim.log.levels.ERROR)
    return nil
  end
  return module_or_err
end

safe_require("configs.core")

local format = safe_require("configs.core.custom.formatting")

format.setup({
  formatters_by_ft = {
    bash = { "shfmt" },                                           -- Bash formatter (shfmt)
    sh = { "shfmt" },                                             -- Shell formatter (shfmt)
    zsh = { "shfmt" },                                            -- Zsh formatter (shfmt)
    c = { "my_cpp" },                                             -- C formatter (clang-format)
    cpp = { "my_cpp" },                                           -- C++ formatter (clang-format)
    css = { "prettier" },                                         -- CSS formatter (prettier)
    go = { "gofmt" },                                             -- Go formatter (gofmt)
    html = { "prettier" },                                        -- HTML formatter (prettier)
    javascript = { "prettier" },                                  -- JavaScript formatter (prettier)
    json = { "prettier" },                                        -- JSON formatter (prettier)
    lua = { "stylua --indent-width 2 --indent-type Spaces" },     -- Lua formatter (stylua)
    markdown = { "prettier" },                                    -- Markdown formatter (prettier)
    nix = { "nixfmt" },                                           -- Nix formatter (nixfmt)
    python = { "isort", "black" },                                -- Python formatters (isort, black)
    rust = { "rust_analyzer" },                                   -- Rust formatter (rustfmt)
    tex = { "tex_fmt" },                                          -- LaTeX formatter (tex-fmt)
    toml = { "taplo" },                                           -- TOML formatter (prettier)
    yml = { "prettier" },                                         -- YAML formatter (prettier)
  },
  format_on_save = true,                                          -- or provide a function(bufnr) returning opts
})

vim.keymap.set({"n","v"}, "<leader>mf", function()
  format.format({
    lsp_fallback      = true,
    async             = false,
    override_disabled = true,    -- ignore FormatDisable
  })
end, { desc = "Format buffer or range" })


if _G.USE_BUILDINS then
  safe_require("configs.core.autocomplete")
  vim.o.syntax = "enable"

  vim.keymap.set('n', '<leader>xx', function()
    local diag = safe_require("configs.core.custom.diagnostic").show_diagnostics()

    if diag == nil then
      return
    end

    diag.show_diagnostics()
  end, {
    noremap = true,
    silent = true,
    desc = 'Show [D]iagnostic [L]ist'
  })

  return
end

safe_require("configs.lazy")
