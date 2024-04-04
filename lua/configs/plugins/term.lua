local function get_term_plugins(include_local_term)
  local plugins = {
    {
      "floork/term.nvim",
      config = function()
        require("term").setup({
          toggle_terminal_key = "<C-t>"
        })
      end
    }
  }

  if include_local_term then
    local term_nvim_path = "~/GIT/GitHub/term.nvim"
    if vim.fn.isdirectory(term_nvim_path) == 1 then
      table.insert(plugins, {
        "term.nvim",
        dir = term_nvim_path,
        config = function()
          require("term").setup({
            toggle_terminal_key = "<C-t>"
          })
        end
      })
    end
  end

  return plugins
end

return get_term_plugins(false)
