return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-telescope/telescope-media-files.nvim",
    "nvim-telescope/telescope-github.nvim",
    "nvim-telescope/telescope-file-browser.nvim",
  },
  opts = {
    defaults = {
      mappings = {
        i = {
          ["<C-j>"] = require("telescope.actions").cycle_history_next,
          ["<C-k>"] = require("telescope.actions").cycle_history_prev,
          ["<C-n>"] = require("telescope.actions").move_selection_next,
          ["<C-p>"] = require("telescope.actions").move_selection_previous,
        },
      },
    },
    pickers = {
      find_files = {
        theme = "dropdown",
      },
    },
    extensions = {
      file_browser = {
        theme = "ivy",
        -- disables netrw and use telescope-file-browser in its place
        hijack_netrw = true,
        -- mappings = {
        --   ["i"] = {
        --     -- your custom insert mode mappings
        --   },
        --   ["n"] = {
        --     -- your custom normal mode mappings
        --   },
        -- },
      },
    },
  },
  config = function(plugin, opts)
    require "plugins.configs.telescope" (plugin, opts)
    local telescope = require "telescope"
    telescope.load_extension "media_files"
    telescope.load_extension "gh"
    telescope.load_extension "file_browser"
  end,
}
