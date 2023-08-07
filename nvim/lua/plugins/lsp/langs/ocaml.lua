return {

  {
    "tjdevries/ocaml.nvim",
    config = function(_, opts) require("ocaml").setup(opts) end,
  },

  -- add json to treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then vim.list_extend(opts.ensure_installed, { "ocaml" }) end
    end,
  },

  -- correctly setup lspconfig
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "b0o/SchemaStore.nvim",
      version = false, -- last release is way too old
    },
    opts = {
      -- make sure mason installs the server
      servers = {
        ocamllsp = {
          get_language_id = function(_, ftype) return ftype end,
        },
      },
    },
  },
}
