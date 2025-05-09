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
  local ft = vim.bo[bufnr].filetype
  local formatters = config.formatters_by_ft[ft]

  -- Respect disable flags unless overridden
  if not opts.override_disabled and is_disabled(bufnr) then
    return
  end

  if formatters and #formatters > 0 then
    for _, fmt in ipairs(formatters) do
      local cmd, args, requires_file
      if type(fmt) == "string" then
        cmd = fmt
        args = nil
        requires_file = false -- Assume simple string commands read from stdin
      else
        cmd = fmt.command
        args = fmt.args
        requires_file = fmt.requires_file or false -- Add a 'requires_file' flag
      end

      local full_cmd = { cmd }
      if args then
        vim.list_extend(full_cmd, args)
      end

      local out
      if requires_file then
        -- Logic to write buffer to a temporary file, run the command on the file,
        -- read the output, and clean up the file.
        local temp_file = vim.fn.tempname() .. "." .. ft -- Create a temporary file

        -- Get buffer lines
        local lines_to_write = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

        -- Write buffer content to temp file using vim.fn.writefile
        vim.fn.writefile(lines_to_write, temp_file)

        -- Add the temporary file to the command
        vim.list_extend(full_cmd, { temp_file })

        local lines = vim.fn.systemlist(full_cmd) -- Run command on the file

        -- Check for shell error immediately after systemlist
        if vim.v.shell_error == 0 then
          -- Read the formatted content back from the temporary file
          local formatted_content = vim.fn.readfile(temp_file)
          out = formatted_content
        else
          vim.notify(
            "Formatter error: " .. cmd .. " on file " .. temp_file .. " (shell error: " .. vim.v.shell_error .. ")",
            vim.log.levels.WARN
          )
        end

        vim.fn.delete(temp_file) -- Clean up the temporary file
      else
        -- Original logic for formatters that read from standard input
        local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
        -- Ensure full_cmd is just the command and args for systemlist with input
        full_cmd = { cmd }
        if args then
          vim.list_extend(full_cmd, args)
        end
        out = vim.fn.systemlist(full_cmd, lines)
      end

      -- Handle errors or deprecation warnings (adjust error handling for file mode)
      if vim.v.shell_error ~= 0 then
        -- Error already notified in the requires_file block, or handle standard input errors here
        if not requires_file then
          vim.notify("Formatter error: " .. cmd, vim.log.levels.WARN)
        end
        break -- Stop processing formatters for this file
      elseif out and out[1] and out[1]:match("Passing directories or non%-Nix files") then
        vim.notify("Skipping deprecated nixfmt. Consider treefmt-nix.", vim.log.levels.WARN)
        break
      elseif out then -- Only apply if output exists (successful formatting)
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
  config.format_on_save = user_cfg.format_on_save or config.format_on_save

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
