local function cmake()
  local cmake_file = "CMakeLists.txt"
  local cmake_exists = vim.loop.fs_stat(cmake_file)
  local build_dir = "build"
  local build_dir_exists = vim.loop.fs_stat(build_dir)

  if not build_dir_exists then
    -- create build directory
    vim.api.nvim_command("!cmake -B" .. build_dir)
  end

  if cmake_exists then
    vim.api.nvim_command("!cmake --build build")
  else
    print("CMakeLists.txt not found in the current directory.")
  end
end

local function cargo()
  vim.api.nvim_command("!cargo build")
end

local function python()
  print("python has no build command")
end

local function go()
  vim.api.nvim_command("!go build")
end

function Build()
  local type = vim.bo.filetype

  local types = {
    ["c"] = cmake,
    ["cpp"] = cmake,
    ["py"] = python,
    ["go"] = go,
    ["rust"] = cargo
  }

  types[type]()
end

local keymap = vim.keymap
keymap.set(
  "n",
  "<leader>bp",
  "<cmd>lua Build()<CR>",
  { noremap = true, silent = true, desc = "Build project" }
)
