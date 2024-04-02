return {
  'Exafunction/codeium.vim',
  event = 'BufEnter',
  config = function()
    vim.g.codeium_enabled = false

    -- keymap
    local keymap = vim.keymap
    local opts = { noremap = true, silent = true }

    opts.desc = "Codeium Chat"
    keymap.set('n', '<leader>cc',
      function() return vim.fn['codeium#Chat']() end,
      opts)
  end
}
