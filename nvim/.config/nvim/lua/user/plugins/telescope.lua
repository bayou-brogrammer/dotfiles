return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/popup.nvim",
    "nvim-lua/plenary.nvim",
    "jvgrootveld/telescope-zoxide",
    "nvim-telescope/telescope-media-files.nvim",
    "jvgrootveld/telescope-zoxide",
  },
  opts = function()
    local z_utils = require "telescope._extensions.zoxide.utils"

    return {
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
        zoxide = {
          prompt_title = "[ Walking on the shoulders of TJ ]",
          mappings = {
            default = {
              after_action = function(selection) print("Update to (" .. selection.z_score .. ") " .. selection.path) end,
            },
            ["<C-s>"] = {
              before_action = function(selection) print "before C-s" end,
              action = function(selection) vim.cmd.edit(selection.path) end,
            },
            -- Opens the selected entry in a new split
            ["<C-\\>"] = { action = z_utils.create_basic_command "split" },
            ["<C-]>"] = { action = z_utils.create_basic_command "vsplit" },
          },
        },
      },
    }
  end,
  config = function(plugin, opts)
    require "plugins.configs.telescope"(plugin, opts)
    local telescope = require "telescope"

    telescope.load_extension "media_files"
    telescope.load_extension "zoxide"

    vim.keymap.set("n", "<leader>cd", telescope.extensions.zoxide.list)
  end,
}
