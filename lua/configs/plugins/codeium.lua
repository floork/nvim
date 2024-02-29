return {
  'Exafunction/codeium.vim',
  event = 'BufEnter',
  config = function()
    vim.g.codeium_disable_bindings = 1

    -- keymap
    local keymap = vim.keymap
    local opts = { noremap = true, silent = true }

    opts.desc = "Codeium Accept"
    keymap.set('i', '<C-l>',
      function() return vim.fn.feedkeys(vim.api.nvim_replace_termcodes(vim.fn["codeium#Accept"](), true, true, true), "") end,
      opts)
    keymap.set('n', '<leader>/',
      function() return vim.fn['codeium#Chat']() end,
      opts)
  end
}
