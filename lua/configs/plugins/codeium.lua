return {
  'Exafunction/codeium.vim',
  event = 'BufEnter',
  config = function()
    -- vim.g.codeium_disable_bindings = 1

    -- keymap
    local keymap = vim.keymap
    local opts = { noremap = true, silent = true }

    opts.desc = "Codeium Chat"
    keymap.set('n', '<leader>cc',
      function() return vim.fn['codeium#Chat']() end,
      opts)
  end
}
