-- Dependencies
-- Widely used by other plugins.
-- It would be ideal using only the ones we need.

--    Sections:
--       -> plenary.nvim     [plenary]
--       -> mini.bufdelete   [required window logic]

-- import custom icons
local get_icon = require("base.utils").get_icon
local windows = vim.fn.has('win32') == 1 -- true if on windows

return {
  --  astrotheme [theme]
  --  https://github.com/AstroNvim/astrotheme
  {
    "AstroNvim/astrotheme",
    event = "User LoadColorSchemes",
    lazy = false,    -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    opts = {
      palette = "astrodark",
      plugins = { ["dashboard-nvim"] = true },
    },
  },

  -- tokyonight [theme]
  -- https://github.com/folke/tokyonight.nvim
  {
    "folke/tokyonight.nvim",
    event = "User LoadColorSchemes",
    lazy = false,    -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    opts = {
      plugins = { ["dashboard-nvim"] = true },
      dim_inactive = true, -- dim inactive windows
    },
  },

  -- plenary.nvim  [plenary]
  -- https://github.com/nvim-lua/plenary.nvim
  --
  -- General methods used by other plugins. (500kb) [plenary]
  -- Enables async and other common functions in pure lua,
  -- which runs faster than vimscript. So it is quite necessary.
  -- We use it for our utils. None of our plugins use it.
  --  METHODS
  --  plenary.async
  --  plenary.async_lib
  --  plenary.job
  --  plenary.path
  --  plenary.scandir
  --  plenary.context_manager
  --  plenary.test_harness
  --  plenary.filetype
  --  plenary.strings
  "nvim-lua/plenary.nvim",

  --  mini.bufremove [required window logic]
  --  https://github.com/echasnovski/mini.bufremove
  --
  -- WARNING:
  -- This plugin is a hard dependency for the current wintab implementation.
  -- If this plugin is deleted, <leader>c and <leader>C will thow error.
  --
  -- It is used by the functions "delete" and "wipe" in
  -- ../base/utils/buffer.lua
  --
  { "echasnovski/mini.bufremove", event = "User BaseFile" },

  -- [ranger] file browser
  -- https://github.com/kevinhwang91/rnvimr
  -- This is NormalNvim file browser, which is only for Linux.
  {
    "kevinhwang91/rnvimr",
    cmd = { "RnvimrToggle" },
    enabled = not windows,
    init = function()
      -- vim.g.rnvimr_vanilla = 1 → Often solves issues in your ranger config.
      vim.g.rnvimr_enable_picker = 1         -- if 1, will close rnvimr after choosing a file.
      vim.g.rnvimr_ranger_cmd = { "ranger" } -- by using a shell script like TERM=foot ranger "$@" we can open terminals inside ranger.
    end,
  },

  -- Improved [esc]
  -- https://github.com/max397574/better-escape.nvim
  {
    "max397574/better-escape.nvim",
    event = "InsertCharPre",
    opts = {
      mapping = {},
      timeout = 300,
    },
  },
}
