Safe_require("configs.core.plugins.tmux_nav").setup()

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
