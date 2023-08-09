-- Useful for easily creating commands
-- local z_utils = require("telescope._extensions.zoxide.utils")

-- You can also add new plugins here as well using the lazy syntax:
return {
  "andweeb/presence.nvim",

  -- Train your mind
  { "tjdevries/train.nvim" },

  -- Hop
  { "phaazon/hop.nvim" },

  -- Best CD Eva
  { "nanotee/zoxide.vim" },

  {
    "nvim-neorg/neorg",
    version = false,
    run = ":Neorg sync-parsers", -- This is the important bit!
    build = ":Neorg sync-parsers",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-neorg/neorg-telescope",

      -- deprecation
      "hrsh7th/nvim-compe",
    },
    config = function()
      require("neorg").setup({
        load = {
          -- Enables support for completion plugins
          ["core.completion"] = {
            config = {
              engine = "nvim-cmp",
            },
          },

          -- Defaults
          ["core.defaults"] = {}, -- Loads default behaviour

          -- Core
          ["core.summary"] = {},
          ["core.concealer"] = {}, -- Adds pretty icons to your documents
          ["core.ui.calendar"] = {},

          ["core.dirman"] = { -- Manages Neorg workspaces
            config = {
              default_workspace = "main",
              workspaces = {
                keepers = "~/notes/keepers",
                main = "~/notes/main",
              },
            },
          },

          -- Developer
          ["core.fs"] = {},
          ["core.ui"] = {},
          ["core.mode"] = {},
          ["core.syntax"] = {},
          ["core.tempus"] = {},
          ["core.storage"] = {},
          ["core.scanner"] = {},
          ["core.neorgcmd"] = {},
          ["core.clipboard"] = {},
          ["core.highlights"] = {},
          ["core.autocommands"] = {},
          ["core.dirman.utils"] = {},
          ["core.queries.native"] = {},
          ["core.neorgcmd.commands.return"] = {},
          ["core.neorgcmd.commands.module.list"] = {},
          ["core.neorgcmd.commands.module.load"] = {},

          -- Integrations
          ["core.integrations.truezen"] = {},
          ["core.integrations.nvim-cmp"] = {},
          ["core.integrations.zen_mode"] = {},
          ["core.integrations.telescope"] = {},
          ["core.integrations.nvim-compe"] = {},
          ["core.integrations.treesitter"] = {},
        },
      })
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      local cmp = require("cmp")
      opts.sources = cmp.config.sources(vim.list_extend(opts.sources, { name = "neorg" }))
    end,
  },
}
