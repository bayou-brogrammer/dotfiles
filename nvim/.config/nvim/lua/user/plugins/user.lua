return {
  {
    "tjdevries/ocaml.nvim",
    config = function()
      require("ocaml").update()
      require("ocaml").setup()
    end,
  },
  { "chentoast/marks.nvim" },
  { "segeljakt/vim-silicon", lazy = false },
  { "folke/zen-mode.nvim",   lazy = false },
  { "mbbill/undotree",       lazy = false },
  {
    "akinsho/git-conflict.nvim",
    config = function()
      require("git-conflict").setup {
        default_mappings = false,
      }
    end,
    lazy = false,
  },
  {
    "m4xshen/hardtime.nvim",
    event = "User AstroFile",
    opts = {
      max_count = 0,
      max_time = 0,
      disable_mouse = false,
      disabled_keys = {
        ["<UP>"] = { "" },
        ["<DOWN>"] = { "" },
        ["<LEFT>"] = { "" },
        ["<RIGHT>"] = { "" },

        ["<Insert>"] = { "", "i" },
        ["<Home>"] = { "", "i" },
        ["<End>"] = { "", "i" },
        ["<PageUp>"] = { "", "i" },
        ["<PageDown>"] = { "", "i" },
      },
      disabled_filetypes = {
        "qf",
        "netrw",
        "NvimTree",
        "lazy",
        "mason",
        "prompt",
        "TelescopePrompt",
        "noice",
        "notify",
        "neo-tree",
      },
    },
  }
}
