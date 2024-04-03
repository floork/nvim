return {
  "L3MON4D3/LuaSnip",
  version = "v2.*",
  build = "make install_jsregexp",
  config = function()
    local ls = require("luasnip")
    local lua_snips = require("configs.plugins.snippets.lua.snippets")

    ls.add_snippets("lua", lua_snips)

    -- keymaps
    local keymap = vim.keymap
    local opts = { noremap = true, silent = true }

    opts.desc = "jump forward"
    keymap.set({ "i", "s" }, "<C-n>", function()
      ls.jump(1)
    end, opts)

    opts.desc = "jump backward"
    keymap.set({ "i", "s" }, "<C-p>", function()
      ls.jump(-1)
    end, opts)
  end,
}
