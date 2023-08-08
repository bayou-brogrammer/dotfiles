return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "AstroNvim/astrolsp", opts = {} },
      {
        "williamboman/mason-lspconfig.nvim", -- MUST be set up before `nvim-lspconfig`
        dependencies = { "williamboman/mason.nvim" },
        opts = function()
          return {
            -- use AstroLSP setup for mason-lspconfig
            handlers = {
              function(server)
                require("astrolsp").lsp_setup(server)
              end,
            },
          }
        end,
      },
    },
    config = function()
      -- set up servers configured with AstroLSP
      vim.tbl_map(require("astrolsp").lsp_setup, require("astrolsp").config.servers)
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    dependencies = {
      { "AstroNvim/astrolsp", opts = {} },
    },
    opts = function()
      return { on_attach = require("astrolsp").on_attach }
    end,
  },
}
