return {
  {
    "rebelot/kanagawa.nvim",
    config = function()
      local kanagawa = require "kanagawa"
      kanagawa.setup {
        theme = "dragon",
        transparent = false,
        background = {     -- map the value of 'background' option to a theme
          dark = "dragon", -- try "dragon" !
          light = "lotus",
        },
      }
    end,
  },
  {
    "Shatur/neovim-ayu",
    config = function()
      local ayu = require "ayu"
      ayu.setup({
        overrides = function()
          if vim.o.background == 'dark' then
            return { NormalNC = { bg = '#0f151e', fg = '#808080' } }
          else
            return { NormalNC = { bg = '#f0f0f0', fg = '#808080' } }
          end
        end
      })
    end,
  },
  { 'nyoom-engineering/oxocarbon.nvim' },

  { "m-pilia/vim-pkgbuild",            lazy = false },
  { "iamcco/markdown-preview.nvim",    lazy = false },
  {
    "akinsho/git-conflict.nvim",
    config = function()
      require("git-conflict").setup {
        default_mappings = false,
        disable_diagnostics = false,
      }
    end,
    lazy = false,
  },
  { "folke/zen-mode.nvim",             lazy = false },
  { "mbbill/undotree",                 lazy = false },
  { "tpope/vim-fugitive",              lazy = false },
  { "Eandrju/cellular-automaton.nvim", lazy = false },
  { "segeljakt/vim-silicon",           lazy = false },
  { "TheBlob42/houdini.nvim",          lazy = false },
  { "mzlogin/vim-markdown-toc",        lazy = false },
  -- {
  --   "ray-x/lsp_signature.nvim",
  --   event = "BufRead",
  --   config = function() require("lsp_signature").setup() end,
  -- },
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = true },
    },
  },
  {
    "lvimuser/lsp-inlayhints.nvim",
    lazy = false,
    config = function()
      local inlay = require "lsp-inlayhints"
      inlay.setup()
    end,
  },
}
