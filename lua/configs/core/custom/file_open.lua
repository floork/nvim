local M = {}

-- Plugin configuration
local config = {
  -- Default settings
  width = 0.8,                                                                        -- Width of the window (percentage of screen width)
  height = 0.8,                                                                       -- Height of the window (percentage of screen height)
  prompt_prefix = "> ",
  use_fd = false,                                                                     -- Whether to use fd instead of find
  fd_command = "fd --type f --color never",                                           -- Base fd command
  find_command = [[find . -type f -not -path '*/\.*' -not -path '*/node_modules/*']], -- Base find command
  custom_command = nil,                                                               -- Custom command for file search
  excludes = {
    ".git",
  },
  include_hidden = false,
}

-- Store state
local state = {
  buf = nil,
  win = nil,
  prompt_buf = nil,
  prompt_win = nil,
  border_win = nil,
  separator_win = nil,
  files = {},
  filtered_files = {},
  input = "",
  timer = nil,
  selected_idx = 1
}

-- Create augroup for our autocommands
local augroup = vim.api.nvim_create_augroup("FileSearch", { clear = true })

-- Helper function for string trimming
local function trim(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end

-- Forward declare functions that need to be accessed in multiple places
local filter_files
local update_display
local debounced_search

-- Disable completion for a specific buffer
---@param buf number Buffer number to disable completion for
local function disable_completion_for_buffer(buf)
  -- Buffer-local options
  local buffer_options = {
    buftype = "nofile",
    complete = "",
    completeopt = "",
    omnifunc = "",
    completefunc = "",
    dictionary = "",
    thesaurus = "",
  }

  -- Set buffer options using vim.bo
  for option, value in pairs(buffer_options) do
    vim.bo[buf][option] = value
  end

  -- Disable LSP
  for _, client in pairs(vim.lsp.get_clients({ bufnr = buf })) do
    if vim.api.nvim_buf_is_valid(buf) then
      vim.lsp.buf_detach_client(buf, client.id)
    end
  end

  -- Try to disable cmp if it exists
  local ok_cmp, cmp = pcall(require, 'cmp')
  if ok_cmp and cmp then
    pcall(function()
      if type(cmp.setup) == 'table' and type(cmp.setup.buffer) == 'function' then
        cmp.setup.buffer({ enabled = false })
      end
    end)
  end

  -- Try to disable blink.cmp if it exists
  local ok_blink, blink_cmp = pcall(require, 'blink.cmp')
  if ok_blink and blink_cmp then
    pcall(function()
      if type(blink_cmp) == 'table' and type(blink_cmp.disable_for_buffer) == 'function' then
        blink_cmp.disable_for_buffer(buf)
      end
    end)
  end

  -- Add autocmd to ensure settings persist
  vim.api.nvim_create_autocmd("BufEnter", {
    buffer = buf,
    group = augroup,
    callback = function()
      vim.opt_local.complete = ""
      vim.opt_local.completeopt = ""
    end
  })

  -- Additional autocmd for TextChangedI
  vim.api.nvim_create_autocmd({ "TextChangedI", "TextChangedP" }, {
    buffer = buf,
    group = augroup,
    callback = function()
      -- Close any open completion windows
      vim.schedule(function()
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-e>', true, true, true), 'n', true)
      end)
    end
  })
end

-- In the plugin file, modify the setup function:
function M.setup(opts)
  opts = opts or {}

  -- Merge user config with defaults
  for k, v in pairs(opts) do
    if config[k] ~= nil then
      config[k] = v
    end
  end

  -- Validate configuration
  config.width = math.min(math.max(config.width, 0.1), 1.0)
  config.height = math.min(math.max(config.height, 0.1), 1.0)

  return M -- Return M to allow chaining
end

-- Build search command based on configuration
local function build_search_command()
  if config.custom_command then
    return config.custom_command
  end

  if config.use_fd then
    -- Check if fd is available
    if vim.fn.executable('fd') ~= 1 then
      vim.notify("fd not found, falling back to find command", vim.log.levels.WARN)
      config.use_fd = false
    else
      local cmd = config.fd_command
      if config.include_hidden then
        cmd = cmd .. " --hidden"
      end
      for _, exclude in ipairs(config.excludes) do
        cmd = cmd .. string.format(" --exclude %s", exclude)
      end
      return cmd
    end
  end

  -- Default find command
  local cmd = config.find_command
  if config.include_hidden then
    cmd = "find . -type f" -- Start fresh without hidden exclusion
    for _, exclude in ipairs(config.excludes) do
      cmd = cmd .. string.format(" -not -path '*/%s/*'", exclude)
    end
  end
  return cmd
end

-- Get all files using the configured search command
local function get_all_files()
  local files = {}
  local command = build_search_command()
  if command == nil then
    vim.notify("No search command configured", vim.log.levels.ERROR)
    return files
  end

  local handle = io.popen(command)

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
  local width = math.floor(vim.o.columns * config.width)
  local height = math.floor(vim.o.lines * config.height)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  -- Adjust heights for all components
  local total_height = height
  local content_height = height - 4 -- -2 for prompt and separator, -2 for top/bottom borders

  -- Create main buffer and window
  state.buf = vim.api.nvim_create_buf(false, true)
  local main_win_opts = {
    relative = "editor",
    width = width,
    height = content_height,
    row = row + 2, -- +1 for top border, +1 for prompt
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
    row = row + 1, -- +1 for top border
    col = col,
    style = "minimal",
    border = "none"
  }
  state.prompt_win = vim.api.nvim_open_win(state.prompt_buf, true, prompt_win_opts)

  -- Disable completion for the prompt buffer
  disable_completion_for_buffer(state.prompt_buf)

  -- Create separator window
  local separator_buf = vim.api.nvim_create_buf(false, true)
  local separator_win_opts = {
    relative = "editor",
    width = width,
    height = 1,
    row = row + 2, -- +1 for top border, +1 for prompt
    col = col,
    style = "minimal",
    border = "none"
  }
  state.separator_win = vim.api.nvim_open_win(separator_buf, false, separator_win_opts)

  -- Add separator line
  vim.api.nvim_buf_set_lines(separator_buf, 0, -1, false, { string.rep("─", width) })

  -- Set buffer options
  vim.bo[state.buf].buftype = "nofile"
  vim.bo[state.buf].swapfile = false
  vim.bo[state.buf].modifiable = true

  vim.bo[state.prompt_buf].buftype = "nofile"
  vim.bo[state.prompt_buf].swapfile = false
  vim.bo[state.prompt_buf].modifiable = true

  -- Set window options
  vim.wo[state.win].cursorline = true

  -- Create border window
  local border_buf = vim.api.nvim_create_buf(false, true)
  local border_opts = {
    relative = "editor",
    width = width + 2,
    height = total_height,
    row = row,
    col = col - 1,
    style = "minimal"
  }
  state.border_win = vim.api.nvim_open_win(border_buf, false, border_opts)

  -- Draw border
  local border_lines = { "╭" .. string.rep("─", width) .. "╮" }
  for _ = 1, total_height - 2 do
    table.insert(border_lines, "│" .. string.rep(" ", width) .. "│")
  end
  table.insert(border_lines, "╰" .. string.rep("─", width) .. "╯")
  vim.api.nvim_buf_set_lines(border_buf, 0, -1, false, border_lines)

  -- Set border buffer options
  vim.bo[border_buf].modifiable = false
  vim.bo[border_buf].bufhidden = "wipe"

  -- Set up key mappings for the prompt buffer
  local opts = { noremap = true, silent = true }
  vim.api.nvim_buf_set_keymap(state.prompt_buf, 'i', '<Up>',
    '<cmd>lua require("configs.core.custom.file_open").move_up()<CR>', opts)
  vim.api.nvim_buf_set_keymap(state.prompt_buf, 'i', '<Down>',
    '<cmd>lua require("configs.core.custom.file_open").move_down()<CR>', opts)
  vim.api.nvim_buf_set_keymap(state.prompt_buf, 'i', '<CR>',
    '<cmd>lua require("configs.core.custom.file_open").select_file()<CR>', opts)
  vim.api.nvim_buf_set_keymap(state.prompt_buf, 'i', '<Esc>',
    '<cmd>lua require("configs.core.custom.file_open").cleanup()<CR>', opts)

  -- Add autocmd for text changes
  vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
    group = augroup,
    buffer = state.prompt_buf,
    callback = function()
      local current_line = vim.api.nvim_buf_get_lines(state.prompt_buf, 0, 1, false)[1] or ""

      -- Check if the prompt is intact
      if not current_line:match("^" .. vim.pesc(config.prompt_prefix)) then
        -- Restore the prompt and any text after it
        local text = trim(current_line:gsub("^" .. vim.pesc(config.prompt_prefix) .. "?", ""):gsub("^>", ""))
        vim.api.nvim_buf_set_lines(state.prompt_buf, 0, -1, false, { config.prompt_prefix .. text })

        -- Move cursor to end of line
        local line_length = #(config.prompt_prefix .. text)
        vim.api.nvim_win_set_cursor(state.prompt_win, { 1, line_length })
      else
        -- Update the input state with trimmed text
        state.input = trim(current_line:gsub("^" .. vim.pesc(config.prompt_prefix), ""))
      end

      debounced_search()
    end
  })
end

-- Filter files based on input
filter_files = function()
  if state.input == "" then
    state.filtered_files = state.files
    return
  end

  local filtered = {}
  local pattern = string.lower(trim(state.input))
  for _, file in ipairs(state.files) do
    if string.lower(file):find(pattern, 1, true) then
      table.insert(filtered, file)
    end
  end
  state.filtered_files = filtered
end

-- Update display
update_display = function()
  if not (state.buf and vim.api.nvim_buf_is_valid(state.buf)) then
    return
  end

  -- Update main buffer
  vim.api.nvim_buf_set_lines(state.buf, 0, -1, false, state.filtered_files)

  -- Update prompt if needed
  if state.prompt_buf and vim.api.nvim_buf_is_valid(state.prompt_buf) then
    local current_line = vim.api.nvim_buf_get_lines(state.prompt_buf, 0, 1, false)[1]
    if not current_line or not current_line:match("^" .. vim.pesc(config.prompt_prefix)) then
      local text = trim((current_line or ""):gsub("^" .. vim.pesc(config.prompt_prefix) .. "?", ""))
      vim.api.nvim_buf_set_lines(state.prompt_buf, 0, -1, false, { config.prompt_prefix .. text })
      -- Move cursor to end of line
      local line_length = #(config.prompt_prefix .. text)
      vim.api.nvim_win_set_cursor(state.prompt_win, { 1, line_length })
    end
  end
end

-- Clean up
local function cleanup()
  if state.timer then
    state.timer:stop()
    state.timer = nil
  end

  -- Clear all autocommands in our group
  vim.api.nvim_clear_autocmds({ group = augroup })

  -- Exit insert mode
  vim.cmd("stopinsert")

  if state.win and vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_win_close(state.win, true)
  end
  if state.prompt_win and vim.api.nvim_win_is_valid(state.prompt_win) then
    vim.api.nvim_win_close(state.prompt_win, true)
  end
  if state.border_win and vim.api.nvim_win_is_valid(state.border_win) then
    vim.api.nvim_win_close(state.border_win, true)
  end
  if state.separator_win and vim.api.nvim_win_is_valid(state.separator_win) then
    vim.api.nvim_win_close(state.separator_win, true)
  end

  state.win = nil
  state.prompt_win = nil
  state.border_win = nil
  state.separator_win = nil
  state.buf = nil
  state.prompt_buf = nil
end

-- Debounced search function
debounced_search = function()
  if state.timer then
    state.timer:stop()
  end

  state.timer = vim.loop.new_timer()
  state.timer:start(200, 0, vim.schedule_wrap(function()
    filter_files()
    update_display()
  end))
end

-- Cursor movement functions
function M.move_up()
  if #state.filtered_files > 0 then
    state.selected_idx = math.max(1, state.selected_idx - 1)
    vim.api.nvim_win_set_cursor(state.win, { state.selected_idx, 0 })
  end
end

function M.move_down()
  if #state.filtered_files > 0 then
    state.selected_idx = math.min(#state.filtered_files, state.selected_idx + 1)
    vim.api.nvim_win_set_cursor(state.win, { state.selected_idx, 0 })
  end
end

-- File selection
function M.select_file()
  local row = vim.api.nvim_win_get_cursor(state.win)[1]
  local file = state.filtered_files[row]
  if file then
    cleanup()
    vim.cmd("stopinsert") -- Exit insert mode before opening the file
    vim.cmd("edit " .. vim.fn.fnameescape(file))
  end
end

-- Make cleanup available to key mappings
function M.cleanup()
  cleanup()
end

-- Search with custom command
function M.search_with_command(command)
  local old_command = config.custom_command
  config.custom_command = command
  M.search()
  config.custom_command = old_command
end

-- Main search function
function M.search()
  state.input = ""
  state.files = get_all_files()
  state.filtered_files = state.files
  state.selected_idx = 1

  create_windows()
  update_display()

  -- Set up autocommands for cleanup
  vim.api.nvim_create_autocmd("BufLeave", {
    group = augroup,
    buffer = state.prompt_buf,
    callback = cleanup
  })

  -- Start insert mode in prompt buffer
  vim.api.nvim_set_current_win(state.prompt_win)
  vim.api.nvim_buf_set_lines(state.prompt_buf, 0, -1, false, { config.prompt_prefix })
  vim.cmd("startinsert!")
  vim.api.nvim_win_set_cursor(state.prompt_win, { 1, #config.prompt_prefix + 1 })
end

-- Set up commands
vim.api.nvim_create_user_command("FileSearch", M.search, {})
vim.api.nvim_create_user_command("FileSearchCustom", function(opts)
  M.search_with_command(opts.args)
end, { nargs = 1 })

return M
