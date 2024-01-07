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
    local cmd = "bash ."
    floating_terminal_buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_option(floating_terminal_buf, "buftype", "nofile")

    -- Calculate width and height as positive integers
    local width = math.floor(vim.fn.winwidth(0) * 0.8)
    local height = math.floor(vim.fn.winheight(0) * 0.8)

    -- Open the window with the new buffer
    floating_terminal_win = vim.api.nvim_open_win(floating_terminal_buf, true, {
      style = "minimal",
      relative = "editor",
      width = width > 0 and width or 1,
      height = height > 0 and height or 1,
      row = vim.fn.ceil((1 - 0.8) * vim.fn.winheight(0) / 2),
      col = vim.fn.ceil((1 - 0.8) * vim.fn.winwidth(0) / 2),
      focusable = true,
      border = "single",
    })

    -- Redirect the Zsh shell to the new buffer
    vim.fn.termopen(cmd, {
      cwd = vim.fn.getcwd(),
      on_exit = function()
        Toggle_floating_terminal()
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
