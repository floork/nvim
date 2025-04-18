local function get_cmd()
  if vim.fn.executable("json-lsp") == 1 then
    return "json-lsp"
  else
    return "vscode-json-language-server"
  end
end


return {
  cmd = { get_cmd() },
  filetypes = { "json" },
}
