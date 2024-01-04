return {
  "NOSDuco/remote-sshfs.nvim",
  dependencies = { "nvim-telescope/telescope.nvim" },
  config = function()
    require("remote-sshfs").setup()
    require("telescope").load_extension("remote-sshfs")

    local keymap = vim.keymap

    local api = require("remote-sshfs.api")
    keymap.set("n", "<leader>rc", api.connect, { silent = true, noremap = true, desc = "Connect to remote host" })
    keymap.set(
      "n",
      "<leader>rd",
      api.disconnect,
      { silent = true, noremap = true, desc = "Disconnect from remote host" }
    )
    keymap.set("n", "<leader>re", api.edit, { silent = true, noremap = true, desc = "Edit remote file" })

    keymap.set(
      "n",
      "<leader>rf",
      "<cmd>RemoteSSHFSFindFiles<cr>",
      { silent = true, noremap = true, desc = "Find files on remote host" }
    )
    keymap.set(
      "n",
      "<leader>rg",
      "<cmd>RemoteSSHFSLiveGrep<cr>",
      { silent = true, noremap = true, desc = "Live grep on remote host" }
    )
  end,
}
