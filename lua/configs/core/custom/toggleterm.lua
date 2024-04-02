-- Variable to track the state of the floating terminal window
local floating_terminal_buf = nil
local floating_terminal_win = nil
local toggle_terminal_key = "<leader>t"

--- Sets the toggle_terminal_key to the specified string key.
-- @param key string The key to set for the terminal toggle.
-- @usage change_terminal_key("example_key")
local function change_terminal_key(key)
  if type(key) == "string" then
    toggle_terminal_key = key
  else
    error("The key must be a string.")
  end
end

-- Function to open or toggle the floating terminal window
function Toggle_floating_terminal()
  -- Check if the floating terminal window exists
  if floating_terminal_win and vim.api.nvim_win_is_valid(floating_terminal_win) then
    -- If the window exists, close it
    vim.api.nvim_win_close(floating_terminal_win, true)
    floating_terminal_buf = nil
    floating_terminal_win = nil
  else
    -- Calculate width and height as positive integers
    local width = math.floor(vim.api.nvim_get_option('columns') * 0.8)
    local height = math.floor(vim.api.nvim_get_option('lines') * 0.8)

    if width < 1 then
      width = 1
    end
    if height < 1 then
      height = 1
    end

    -- Create the buffer if not already existing
    if not floating_terminal_buf or not vim.api.nvim_buf_is_valid(floating_terminal_buf) then
      floating_terminal_buf = vim.api.nvim_create_buf(true, false) -- Set "listed" to true
    end

    -- Open the window with the existing buffer
    floating_terminal_win = vim.api.nvim_open_win(floating_terminal_buf, true, {
      style = "minimal",
      relative = "editor",
      width = width,
      height = height,
      row = math.floor((vim.api.nvim_get_option("lines") - height) / 2),
      col = math.floor((vim.api.nvim_get_option("columns") - width) / 2),
      focusable = true,
      border = "double",
      title = "Terminal",
    })

    local cmd = "zsh"
    -- Redirect the Zsh shell to the existing buffer
    vim.fn.termopen(cmd, {
      cwd = vim.fn.getcwd(),
      on_exit = function()
        Toggle_floating_terminal()
      end,
    })

    -- Enter terminal mode after opening the terminal
    vim.api.nvim_buf_set_keymap(floating_terminal_buf, 't', '<C-\\><C-n>', '<C-\\><C-n><cmd>stopinsert<CR>',
      { noremap = true })
    vim.api.nvim_buf_set_keymap(floating_terminal_buf, 't', toggle_terminal_key,
      '<cmd>lua Toggle_floating_terminal()<CR>',
      { noremap = true })

    -- Enter insert mode after opening the terminal
    vim.cmd('startinsert')
  end
end

-- Map a key to toggle the floating terminal or switch to term mode
local keymap = vim.keymap
change_terminal_key("<C-t>")

keymap.set(
  "n",
  toggle_terminal_key,
  "<cmd>lua Toggle_floating_terminal()<CR>",
  { noremap = true, silent = true, desc = "Toggle floating terminal or switch to term mode" }
)
