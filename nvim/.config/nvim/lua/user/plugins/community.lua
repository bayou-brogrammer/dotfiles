return {
  -- Add the community repository of plugin specifications
  "AstroNvim/astrocommunity",
  -- example of imporing a plugin, comment out to use it or add your own
  -- available plugins can be found at https://github.com/AstroNvim/astrocommunity
  -- { import = "astrocommunity.colorscheme.catppuccin" },



  { import = "astrocommunity.diagnostics.trouble-nvim" },
  { import = "astrocommunity.diagnostics.lsp_lines-nvim" },

  { import = "astrocommunity.lsp.lsp-inlayhints-nvim" },
  { import = "astrocommunity.code-runner.overseer-nvim" },
  { import = "astrocommunity.fuzzy-finder.telescope-zoxide" },


  { import = "astrocommunity.pack.rust" },
  { import = "astrocommunity.pack.python" },
  { import = "astrocommunity.pack.typescript" },
  { import = "astrocommunity.pack.typescript-deno" },

  { import = "astrocommunity.git.neogit" },
  { import = "astrocommunity.git.diffview-nvim" },
  { import = "astrocommunity.git.git-blame-nvim" },

  --
  { import = "astrocommunity.utility.noice-nvim" },
  { import = "astrocommunity.color.modes-nvim" },
  { import = "astrocommunity.scrolling.mini-animate" },
  { import = "astrocommunity.bars-and-lines.feline-nvim" },
  { import = "astrocommunity.colorscheme.nightfox-nvim",              enabled = true },
  { import = "astrocommunity.completion.copilot-lua-cmp" },

  --
  { import = "astrocommunity.motion.harpoon" },
  { import = "astrocommunity.motion.hop-nvim" },
  { import = "astrocommunity.motion.nvim-spider" },

  --
  { import = "astrocommunity.bars-and-lines.lualine-nvim" },
  { import = "astrocommunity.bars-and-lines.smartcolumn-nvim" },

  --
  { import = "astrocommunity.editing-support.vim-move" },
  { import = "astrocommunity.editing-support.chatgpt-nvim" },
  { import = "astrocommunity.editing-support.comment-box-nvim" },
  { import = "astrocommunity.editing-support.rainbow-delimiters-nvim" },

  --
  { import = "astrocommunity.workflow.hardtime-nvim" },
  { import = "astrocommunity.workflow.bad-practices-nvim" },


  -- { -- further customize the options set by the community
  {
    "m4xshen/hardtime.nvim",
    opts = {
      max_time = 100000,
      max_count = 1000,
      disable_mouse = false,
      disabled_keys = {
        ["<UP>"] = { "" },
        ["<DOWN>"] = { "" },
        ["<LEFT>"] = { "" },
        ["<RIGHT>"] = { "" },
      },
    }
  },
  {
    "zbirenbaum/copilot.lua",
    opts = {
      suggestion = {
        keymap = {
          accept = "<C-l>",
          accept_word = false,
          accept_line = false,
          next = "<C-.>",
          prev = "<C-,>",
          dismiss = "<C/>",
        },
      },
    },
  },

  {
    "m4xshen/smartcolumn.nvim",
    opts = {
      colorcolumn = 120,
      disabled_filetypes = { "help" },
    },
  },

  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      -- add any options here
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
    }
  },

  {
    "fladson/vim-kitty",
    opts ={}
  }
}
