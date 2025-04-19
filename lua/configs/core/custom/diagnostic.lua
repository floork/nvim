local api = vim.api
local M = {}

-- Helper to map severity enum to a short string
local function get_severity_str(severity)
  local severity_map = {
    [vim.diagnostic.severity.ERROR] = "E",
    [vim.diagnostic.severity.WARN] = "W",
    [vim.diagnostic.severity.INFO] = "I",
    [vim.diagnostic.severity.HINT] = "H",
  }
  return severity_map[severity] or "?"
end

-- Function to show the diagnostics list for the workspace
function M.show_diagnostics()
  print("Gathering diagnostics using vim.diagnostic.get(bufnr)...") -- Debug message

  local all_diagnostics = {}
  local buffer_filenames = {} -- Cache filenames

  -- Manually iterate through loaded buffers
  local loaded_buffers = api.nvim_list_bufs()
  for _, bufnr in ipairs(loaded_buffers) do
    -- Ensure buffer is still valid and loaded
    if api.nvim_buf_is_valid(bufnr) and api.nvim_buf_is_loaded(bufnr) then
      -- Get diagnostics for this specific buffer using the documented get()
      local diagnostics = vim.diagnostic.get(bufnr) -- <<< Using get(bufnr)

      -- Only process if there are diagnostics for this buffer
      if diagnostics and #diagnostics > 0 then
        local filename = api.nvim_buf_get_name(bufnr)
        if filename == "" then
          filename = "[No Name " .. bufnr .. "]"
        else
          filename = vim.fn.fnamemodify(filename, ":.") -- Relative path
        end
        buffer_filenames[bufnr] = filename

        -- Add buffer number and filename info to each diagnostic item
        for _, diag in ipairs(diagnostics) do
          diag.bufnr = bufnr
          diag.filename = filename
          table.insert(all_diagnostics, diag)
        end
      end
    end
  end

  if #all_diagnostics == 0 then
    print("No diagnostics found in workspace.")
    return
  end

  -- Sort all collected diagnostics: by filename, then line number, then column
  table.sort(all_diagnostics, function(a, b)
    if a.filename ~= b.filename then
      return a.filename < b.filename
    end
    if a.lnum ~= b.lnum then
      return a.lnum < b.lnum
    end
    return a.col < b.col
  end)

  local lines = {}
  local diag_map = {} -- Map display line number to actual diagnostic info
  local max_width = 0

  -- Add a header indicating workspace scope
  table.insert(lines, "Workspace Diagnostics (using get)")
  table.insert(lines, string.rep("-", #lines[1]))

  -- Format each diagnostic line, now including the filename
  for i, diag in ipairs(all_diagnostics) do
    local line_num = diag.lnum + 1
    local col_num = diag.col + 1
    local severity = get_severity_str(diag.severity)
    local source = diag.source or "N/A"
    local message = diag.message:gsub("\n", " ")

    -- Format: [S] <filename>:L<line>:<col> <message> (<source>)
    local line_str = string.format(
      "[%s] %s:%d:%d %s (%s)",
      severity,
      diag.filename, -- Include filename here
      line_num,
      col_num,
      message,
      source
    )
    table.insert(lines, line_str)
    -- Store diagnostic info, mapping the *display* line number
    diag_map[i + 2] = {
      bufnr = diag.bufnr, -- Use the stored bufnr
      lnum = diag.lnum,
      col = diag.col,
    }
    max_width = math.max(max_width, #line_str)
  end

  -- Calculate window dimensions
  local editor_width = api.nvim_get_option_value("columns", {})
  local editor_height = api.nvim_get_option_value("lines", {})
  local win_height = math.min(#lines, math.floor(editor_height * 0.7))
  local win_width = math.min(max_width + 4, math.floor(editor_width * 0.9))
  local win_row = math.floor((editor_height - win_height) / 2)
  local win_col = math.floor((editor_width - win_width) / 2)

  -- Create scratch buffer
  local buf = api.nvim_create_buf(false, true)
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].filetype = "simplediaglist"
  -- Set the lines *while* the buffer is still modifiable (default)
  api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  -- NOW make the buffer non-modifiable for the user
  vim.bo[buf].modifiable = false -- <<< MOVED HERE

  -- Store data needed for jump logic
  vim.b[buf].simple_diag_map = diag_map
  local original_win = api.nvim_get_current_win()
  vim.b[buf].simple_diag_original_win = original_win

  -- Define the jump logic as a local function
  local function jump_to_diagnostic_from_float()
    local current_win = api.nvim_get_current_win()
    local current_buf = api.nvim_get_current_buf()
    local map = vim.b[current_buf].simple_diag_map
    local orig_win = vim.b[current_buf].simple_diag_original_win
    if not map or not orig_win then
      print("Error: Could not retrieve diagnostic data.")
      return
    end
    local cursor_pos = api.nvim_win_get_cursor(current_win)
    local display_line_num = cursor_pos[1]
    local diag_info = map[display_line_num]
    if diag_info then
      api.nvim_win_close(current_win, true)
      if api.nvim_buf_is_valid(diag_info.bufnr) then
        -- Use :buffer command to switch/focus the target buffer's window
        vim.cmd(api.nvim_buf_get_number(diag_info.bufnr) .. "buffer")
        local target_win_id = vim.fn.bufwinid(diag_info.bufnr)
        if target_win_id ~= -1 then
          api.nvim_set_current_win(target_win_id)
          api.nvim_win_set_cursor(target_win_id, { diag_info.lnum + 1, diag_info.col })
        else
          api.nvim_win_set_cursor(0, { diag_info.lnum + 1, diag_info.col })
        end
      else
        print("Error: Target buffer for diagnostic is no longer valid.")
      end
    end
  end
  -- Store the function itself in a buffer variable
  vim.b[buf].jump_function = jump_to_diagnostic_from_float

  -- Open floating window
  local win = api.nvim_open_win(buf, true, {
    relative = "editor",
    width = win_width,
    height = win_height,
    row = win_row,
    col = win_col,
    style = "minimal",
    border = "rounded",
  })
  api.nvim_win_set_option(win, "cursorline", true)

  -- Define buffer-local keymaps
  api.nvim_buf_set_keymap(
    buf,
    "n",
    "q",
    "<Cmd>close<CR>",
    { noremap = true, silent = true, nowait = true, desc = "Close list" }
  )
  local jump_cmd =
  "<Cmd>lua vim.b[vim.api.nvim_get_current_buf()].jump_function()<CR>"
  api.nvim_buf_set_keymap(
    buf,
    "n",
    "<CR>",
    jump_cmd,
    { noremap = true, silent = true, nowait = true, desc = "Jump to diagnostic" }
  )
  api.nvim_buf_set_keymap(
    buf,
    "n",
    "<2-LeftMouse>",
    jump_cmd,
    { noremap = true, silent = true, nowait = true, desc = "Jump to diagnostic" }
  )
  api.nvim_buf_set_keymap(
    buf,
    "n",
    "n",
    "j",
    { noremap = true, silent = true, desc = "Next diagnostic item" }
  )
  api.nvim_buf_set_keymap(
    buf,
    "n",
    "N",
    "k",
    { noremap = true, silent = true, desc = "Previous diagnostic item" }
  )
  api.nvim_buf_set_keymap(
    buf,
    "n",
    "j",
    "j",
    { noremap = true, silent = true, desc = "Next diagnostic item" }
  )
  api.nvim_buf_set_keymap(
    buf,
    "n",
    "k",
    "k",
    { noremap = true, silent = true, desc = "Previous diagnostic item" }
  )
end

return M
