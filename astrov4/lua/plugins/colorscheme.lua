return {
  -- kanagawa
  -- { "rebelot/kanagawa.nvim", lazy = true },

  -- oxocarbon
  { "nyoom-engineering/oxocarbon.nvim", lazy = true },

  -- starry
  { "ray-x/starry.nvim", lazy = true },

  {
    "olimorris/onedarkpro.nvim",
    opts = {
      options = {
        highlight_inactive_windows = true,
      },
    },
  },

  -- mini
  {
    "echasnovski/mini.base16",
    lazy = true,
    {
      "catppuccin/nvim",
      optional = true,
      opts = { integrations = { mini = true } },
    },
  },

  -- -- onedarker
  { "lunarvim/Onedarker.nvim", lazy = true },

  -- Terafox
  -- Nordfox
  -- Duskfox
  {
    "EdenEast/nightfox.nvim",
    lazy = true,
    opts = {
      options = {
        module_default = false,
        modules = {
          aerial = true,
          cmp = true,
          ["dap-ui"] = true,
          dashboard = true,
          diagnostic = true,
          gitsigns = true,
          native_lsp = true,
          neotree = true,
          notify = true,
          symbol_outline = true,
          telescope = true,
          treesitter = true,
          whichkey = true,
        },
      },
      groups = { all = { NormalFloat = { link = "Normal" } } },
    },
  },

  -- tokyonight
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = { style = "moon" },
  },

  -- catppuccin
  {
    "catppuccin/nvim",
    priority = 1000,
    name = "catppuccin",
    opts = {
      flavour = "frappe", -- latte, frappe, macchiato, mocha
      background = { -- :h background
        light = "latte",
        dark = "mocha",
      },
      integrations = {
        alpha = true,
        cmp = true,
        flash = false,
        gitsigns = true,
        illuminate = true,
        indent_blankline = { enabled = true },
        lsp_trouble = true,
        mason = true,
        mini = true,
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
        navic = { enabled = true, custom_bg = "lualine" },
        neotest = true,
        noice = true,
        notify = true,
        neotree = true,
        semantic_tokens = true,
        telescope = true,
        treesitter = true,
        which_key = true,
      },
    },
  },
}
