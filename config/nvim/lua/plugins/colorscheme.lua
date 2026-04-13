return {
  {
    "navarasu/onedark.nvim",
    name = "onedark",
    priority = 1000,
    opts = {
      style = "dark",
      integrations = {
        cmp = true,
        gitsigns = true,
        neo_tree = true,
        treesitter = true,
        telescope = { enabled = true },
        indent_blankline = { enabled = true },
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
        which_key = true,
      },
    },
    config = function(_, opts)
      require("onedark").setup(opts)
      vim.cmd.colorscheme("onedark")
    end,
  },
}
