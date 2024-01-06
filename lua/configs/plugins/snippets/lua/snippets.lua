local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

------------------------------------------------------------------------------------------
-- ======== Lua snippets ========
------------------------------------------------------------------------------------------

local lua_snippets = {
  ls.parser.parse_snippet({ trig = "con", name = "config" }, "config = function()\n $0\nend"),
}

return lua_snippets
