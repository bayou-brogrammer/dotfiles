return {
  -- Add the community repository of plugin specifications
  "AstroNvim/astrocommunity",
  -- example of imporing a plugin, comment out to use it or add your own
  -- available plugins can be found at https://github.com/AstroNvim/astrocommunity
  -- { import = "astrocommunity.colorscheme.catppuccin" },

  { import = "astrocommunity.colorscheme.nightfox-nvim", enabled = true },
  { import = "astrocommunity.code-runner.overseer-nvim" },
  { import = "astrocommunity.fuzzy-finder.telescope-zoxide" },
  { import = "astrocommunity.diagnostics.trouble-nvim" },
  { import = "astrocommunity.motion.hop-nvim" },
  { import = "astrocommunity.motion.harpoon" },
  { import = "astrocommunity.lsp.lsp-inlayhints-nvim" },

  { import = "astrocommunity.pack.go" },
  { import = "astrocommunity.pack.rust" },
  { import = "astrocommunity.pack.python" },
  -- { import = "astrocommunity.pack.tailwind" },
  { import = "astrocommunity.pack.typescript-all-in-one" },

  { import = "astrocommunity.scrolling.mini-animate" },
  { import = "astrocommunity.git.neogit" },
  { import = "astrocommunity.git.diffview-nvim" },
  { import = "astrocommunity.git.git-blame-nvim" },
  { import = "astrocommunity.bars-and-lines.feline-nvim" },
  { import = "astrocommunity.color.modes-nvim" },


  { import = "astrocommunity.completion.copilot-lua-cmp" },
  -- { -- further customize the options set by the community
  --   "copilot-lua",
  --   opts = {
  --     suggestion = {
  --       keymap = {
  --         accept = "<C-l>",
  --         accept_word = false,
  --         accept_line = false,
  --         next = "<C-.>",
  --         prev = "<C-,>",
  --         dismiss = "<C/>",
  --       },
  --     },
  --   },
  -- },

  { import = "astrocommunity.bars-and-lines.smartcolumn-nvim" },
  {
    "m4xshen/smartcolumn.nvim",
    opts = {
      colorcolumn = 120,
      disabled_filetypes = { "help" },
    },
  },
}