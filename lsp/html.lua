local function get_cmd()
  if vim.fn.executable('html-lsp') == 1 then
    return 'html-lsp'
  else
    return 'vscode-html-language-server'
  end
end

return {
  cmd = { get_cmd() },
  filetypes = { "html" },
}
