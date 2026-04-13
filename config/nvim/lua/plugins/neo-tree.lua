return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    cmd = "Neotree",
    keys = {
      { "<leader>e", "<cmd>Neotree toggle<CR>", desc = "Toggle file [E]xplorer" },
      { "<leader>o", "<cmd>Neotree focus<CR>", desc = "F[o]cus file explorer" },
    },
    opts = {
      filesystem = {
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
        filtered_items = {
          hide_dotfiles = false,
          hide_by_name = {
            "node_modules",
            "bin",
            "obj",
            ".git",
          },
        },
      },
      window = {
        width = 35,
        mappings = {
          ["<space>"] = "none",
        },
      },
    },
  },
}
