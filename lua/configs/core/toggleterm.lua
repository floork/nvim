-- Variable to track the state of the floating terminal window
local floating_terminal_buf = nil
local floating_terminal_win = nil

-- Function to open or toggle the floating terminal window
function Toggle_floating_terminal()
  if floating_terminal_buf and vim.api.nvim_buf_is_valid(floating_terminal_buf) then
    -- If the buffer is open, close it
    vim.api.nvim_win_close(floating_terminal_win, true)
    floating_terminal_buf = nil
    floating_terminal_win = nil
  else
    -- If the buffer is closed, open it with Zsh
    local cmd = "zsh"

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
      border = "single",
    })

    -- Redirect the Zsh shell to the existing buffer
    vim.fn.termopen(cmd, {
      cwd = vim.fn.getcwd(),
      on_exit = function()
        Toggle_floating_terminal()
      end,
      -- Ensure terminal starts in insert mode
      on_start = function(jobid)
        vim.api.nvim_feedkeys("i", "n", true)
      end,
    })
  end
end

-- Map a key to toggle the floating terminal
local keymap = vim.keymap
keymap.set(
  "n",
  "<leader>t",
  "<cmd>lua Toggle_floating_terminal()<CR>",
  { noremap = true, silent = true, desc = "Toggle floating terminal" }
)
