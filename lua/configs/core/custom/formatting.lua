local M = {}

-- Default configuration
local config = {
  formatters_by_ft = {},
  format_on_save = false,
}

-- Check if autoformatting is disabled for a buffer
local function is_disabled(bufnr)
  return vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat
end

-- Run an external formatter or LSP fallback for the buffer
-- opts.override_disabled: boolean, if true, ignore disable flags
function M.format(opts)
  opts = opts or {}
  local bufnr = opts.bufnr or vim.api.nvim_get_current_buf()
  local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")
  local formatters = config.formatters_by_ft[ft]

  -- Respect disable flags unless overridden
  if not opts.override_disabled and is_disabled(bufnr) then
    return
  end

  if formatters and #formatters > 0 then
    for _, fmt in ipairs(formatters) do
      local cmd, args
      if type(fmt) == "string" then
        cmd = fmt; args = nil
      else
        cmd = fmt.command; args = fmt.args
      end

      local full_cmd = {}
      if args then
        full_cmd = { cmd, unpack(args) }
      else
        full_cmd = { "sh", "-c", cmd .. " 2>/dev/null" }
      end

      local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
      local out = vim.fn.systemlist(full_cmd, lines)

      -- Handle errors or deprecation warnings
      if vim.v.shell_error ~= 0 then
        vim.notify("Formatter error: " .. cmd, vim.log.levels.WARN)
        break
      elseif out[1] and out[1]:match("Passing directories or non%-Nix files") then
        vim.notify("Skipping deprecated nixfmt. Consider treefmt-nix.", vim.log.levels.WARN)
        break
      else
        vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, out)
      end
    end
  elseif opts.lsp_fallback then
    vim.lsp.buf.format({ async = opts.async })
  end
end

-- Setup plugin with user configuration
function M.setup(user_cfg)
  user_cfg = user_cfg or {}
  config.formatters_by_ft = user_cfg.formatters_by_ft or config.formatters_by_ft
  config.format_on_save    = user_cfg.format_on_save  or config.format_on_save

  -- Autoformat on save
  if config.format_on_save then
    vim.api.nvim_create_autocmd("BufWritePre", {
      callback = function(args)
        M.format({ bufnr = args.buf, lsp_fallback = true, async = false })
      end,
    })
  end

  -- Commands to enable/disable autoformat
  vim.api.nvim_create_user_command("FormatEnable", function()
    vim.g.disable_autoformat = false
    vim.b[vim.api.nvim_get_current_buf()].disable_autoformat = false
  end, { desc = "Enable autoformat" })

  vim.api.nvim_create_user_command("FormatDisable", function(opts)
    if opts.bang then
      vim.b[vim.api.nvim_get_current_buf()].disable_autoformat = true
    else
      vim.g.disable_autoformat = true
    end
  end, { bang = true, desc = "Disable autoformat" })
end

return M
