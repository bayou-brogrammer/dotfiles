return {
  -- onedark
  { "nyoom-engineering/oxocarbon.nvim", lazy = true },

  -- starry
  { "ray-x/starry.nvim", lazy = true },

  -- onedark
  { "navarasu/onedark.nvim", opts = { style = "darker" }, lazy = true },

  -- onedarker
  { "lunarvim/Onedarker.nvim", lazy = true },

  -- Nightfox
  -- Carbonfox
  -- Terafox
  -- Nordfox
  -- Duskfox
  { "EdenEast/nightfox.nvim", lazy = true },

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
        flash = true,
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
