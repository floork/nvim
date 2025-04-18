local M = {}

-- Store state
local state = {
  buf = nil,
  win = nil,
  prompt_buf = nil,
  prompt_win = nil,
  border_win = nil,
  files = {},
  filtered_files = {},
  input = "",
  timer = nil
}

-- Get all files in the current directory
local function get_all_files()
  local files = {}
  local handle = io.popen(
    [[find . -type f -not -path '*/\.*' -not -path '*/node_modules/*']]
  )
  if handle then
    for file in handle:lines() do
      file = file:gsub("^%./", "")
      table.insert(files, file)
    end
    handle:close()
  end
  return files
end

-- Create windows
local function create_windows()
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  -- Create main buffer and window
  state.buf = vim.api.nvim_create_buf(false, true)
  local main_win_opts = {
    relative = "editor",
    width = width,
    height = height - 1,
    row = row + 1,
    col = col,
    style = "minimal",
    border = "none"
  }
  state.win = vim.api.nvim_open_win(state.buf, false, main_win_opts)

  -- Create prompt buffer and window
  state.prompt_buf = vim.api.nvim_create_buf(false, true)
  local prompt_win_opts = {
    relative = "editor",
    width = width,
    height = 1,
    row = row,
    col = col,
    style = "minimal",
    border = "none"
  }
  state.prompt_win = vim.api.nvim_open_win(state.prompt_buf, true, prompt_win_opts)

  -- Set buffer options
  vim.api.nvim_buf_set_option(state.buf, "buftype", "nofile")
  vim.api.nvim_buf_set_option(state.buf, "swapfile", false)
  vim.api.nvim_buf_set_option(state.buf, "modifiable", true)

  vim.api.nvim_buf_set_option(state.prompt_buf, "buftype", "nofile")
  vim.api.nvim_buf_set_option(state.prompt_buf, "swapfile", false)
  vim.api.nvim_buf_set_option(state.prompt_buf, "modifiable", true)

  -- Set window options
  vim.api.nvim_win_set_option(state.win, "cursorline", true)

  -- Create border window
  local border_buf = vim.api.nvim_create_buf(false, true)
  local border_opts = {
    relative = "editor",
    width = width + 2,
    height = height + 1,
    row = row - 1,
    col = col - 1,
    style = "minimal"
  }
  state.border_win = vim.api.nvim_open_win(border_buf, false, border_opts)

  -- Draw border
  local border_lines = { "╭" .. string.rep("─", width) .. "╮" }
  for _ = 1, height - 1 do
    table.insert(border_lines, "│" .. string.rep(" ", width) .. "│")
  end
  table.insert(border_lines, "╰" .. string.rep("─", width) .. "╯")
  vim.api.nvim_buf_set_lines(border_buf, 0, -1, false, border_lines)
end

-- Filter files based on input
local function filter_files()
  if state.input == "" then
    state.filtered_files = state.files
    return
  end

  local filtered = {}
  local pattern = string.lower(state.input)
  for _, file in ipairs(state.files) do
    if string.lower(file):find(pattern, 1, true) then
      table.insert(filtered, file)
    end
  end
  state.filtered_files = filtered
end

-- Update display
local function update_display()
  if not (state.buf and vim.api.nvim_buf_is_valid(state.buf)) then
    return
  end

  -- Update main buffer
  vim.api.nvim_buf_set_lines(state.buf, 0, -1, false, state.filtered_files)

  -- Update prompt
  if state.prompt_buf and vim.api.nvim_buf_is_valid(state.prompt_buf) then
    vim.api.nvim_buf_set_lines(state.prompt_buf, 0, -1, false, { "> " .. state.input })
  end
end

-- Clean up
local function cleanup()
  if state.timer then
    state.timer:stop()
    state.timer = nil
  end

  if state.win and vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_win_close(state.win, true)
  end
  if state.prompt_win and vim.api.nvim_win_is_valid(state.prompt_win) then
    vim.api.nvim_win_close(state.prompt_win, true)
  end
  if state.border_win and vim.api.nvim_win_is_valid(state.border_win) then
    vim.api.nvim_win_close(state.border_win, true)
  end

  state.win = nil
  state.prompt_win = nil
  state.border_win = nil
  state.buf = nil
  state.prompt_buf = nil
  vim.on_key(nil)
end

-- Debounced search function
local function debounced_search()
  if state.timer then
    state.timer:stop()
  end

  state.timer = vim.loop.new_timer()
  state.timer:start(200, 0, vim.schedule_wrap(function()
    filter_files()
    update_display()
  end))
end

-- Handle character input
local function handle_char(char)
  if not (state.prompt_buf and vim.api.nvim_buf_is_valid(state.prompt_buf)) then
    return
  end

  if char == vim.api.nvim_replace_termcodes("<CR>", true, false, true) then
    local selected_idx = vim.api.nvim_win_get_cursor(state.win)[1]
    local selected_file = state.filtered_files[selected_idx]
    if selected_file then
      cleanup()
      vim.cmd("edit " .. vim.fn.fnameescape(selected_file))
    end
    return
  end

  if char == vim.api.nvim_replace_termcodes("<ESC>", true, false, true) then
    cleanup()
    return
  end

  if char == vim.api.nvim_replace_termcodes("<BS>", true, false, true) then
    state.input = string.sub(state.input, 1, -2)
  else
    state.input = state.input .. char
  end

  -- Update prompt immediately
  vim.api.nvim_buf_set_lines(state.prompt_buf, 0, -1, false, { "> " .. state.input })

  -- Debounce the search
  debounced_search()
end

-- Main search function
function M.search()
  state.input = ""
  state.files = get_all_files()
  state.filtered_files = state.files

  create_windows()
  update_display()

  -- Set up autocommands for cleanup
  local augroup = vim.api.nvim_create_augroup("FileSearch", { clear = true })
  vim.api.nvim_create_autocmd("BufLeave", {
    group = augroup,
    buffer = state.prompt_buf,
    callback = cleanup
  })

  -- Start insert mode in prompt buffer
  vim.api.nvim_set_current_win(state.prompt_win)
  vim.cmd("startinsert")

  -- Handle input
  vim.on_key(function(char)
    if state.prompt_buf then
      handle_char(char)
    end
  end)
end

-- Set up command
vim.api.nvim_create_user_command("FileSearch", M.search, {})

return M
