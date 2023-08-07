return {
  -- [[ Train Vim Motions ]]
  { "tjdevries/train.nvim" },

  -- [[ Better Escape ]]
  { "max397574/better-escape.nvim", event = "InsertCharPre", opts = { timeout = 300 } },

  -- [[ IDENT ]]
  { "NMAC427/guess-indent.nvim", event = "User KickstartFile", config = require "plugins.configs.guess-indent" },

  -- measure startuptime
  {
    "dstein64/vim-startuptime",
    cmd = "StartupTime",
    config = function() vim.g.startuptime_tries = 10 end,
  },

  -- library used by other plugins
  { "nvim-lua/plenary.nvim", lazy = true },

  -- [[
  -- SESSIONS
  --]]
  {
    "rmagatti/auto-session",
    opts = {
      log_level = vim.log.levels.ERROR,
      auto_session_suppress_dirs = { "~/", "~/Downloads", "/" },
      auto_session_use_git_branch = false,

      auto_session_enable_last_session = false,

      -- ⚠️ This will only work if Telescope.nvim is installed
      -- The following are already the default values, no need to provide them if these are already the settings you want.
      session_lens = {
        -- If load_on_setup is set to false, one needs to eventually call `require("auto-session").setup_session_lens()` if they want to use session-lens.
        previewer = false,
        load_on_setup = true,
        theme_conf = { border = true },
      },
    },
  },

  -- Session management. This saves your session in the background,
  -- keeping track of open buffers, window arrangement, and more.
  -- You can restore sessions when returning through the dashboard.
  -- {
  --   "folke/persistence.nvim",
  --   event = "BufReadPre",
  --   opts = { options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp" } },
  --   -- stylua: ignore
  --   keys = {
  --     { "<leader>qs", function() require("persistence").load() end, desc = "Restore Session" },
  --     { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
  --     { "<leader>qd", function() require("persistence").stop() end, desc = "Don't Save Current Session" },
  --   },
  -- },

  {
    "stevearc/resession.nvim",
    enabled = vim.g.resession_enabled == true,
    opts = {
      buf_filter = function(bufnr) return require("kickstart.utils.buffer").is_restorable(bufnr) end,
      tab_buf_filter = function(tabpage, bufnr) return vim.tbl_contains(vim.t[tabpage].bufs, bufnr) end,
      extensions = { kickstartnvim = {} },
    },
  },
}
