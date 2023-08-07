return {
  {
    "nvim-telescope/telescope-file-browser.nvim",
    lazy = false,
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
  },

  {
    "nvim-telescope/telescope.nvim",
    version = false, -- telescope did only one release, so use HEAD for now
    commit = vim.fn.has "nvim-0.9.0" == 0 and "057ee0f8783" or nil,
    dependencies = {
      { "nvim-telescope/telescope-fzf-native.nvim", enabled = vim.fn.executable "make" == 1, build = "make" },
    },
    cmd = "Telescope",
    opts = function()
      local actions = require "telescope.actions"
      local utils = require "kickstart.utils"
      local get_icon = utils.get_icon

      return {
        extensions = {
          file_browser = {
            -- theme = "ivy",
            -- disables netrw and use telescope-file-browser in its place
            hijack_netrw = false,
            mappings = {
              ["i"] = {
                ["<C-e>"] = require("telescope.actions").close,
              },
              ["n"] = {
                ["<leader>e"] = require("telescope.actions").close,
              },
            },
          },
        },
        defaults = {
          git_worktrees = vim.g.git_worktrees,
          prompt_prefix = get_icon("Selected", 1),
          selection_caret = get_icon("Selected", 1),
          path_display = { "truncate" },
          sorting_strategy = "ascending",
          layout_config = {
            horizontal = { prompt_position = "top", preview_width = 0.55 },
            vertical = { mirror = false },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
          },
          mappings = {
            i = {
              ["<c-t>"] = function(...) return require("trouble.providers.telescope").open_with_trouble(...) end,
              ["<a-t>"] = function(...) return require("trouble.providers.telescope").open_selected_with_trouble(...) end,
              ["<a-i>"] = function()
                local action_state = require "telescope.actions.state"
                local line = action_state.get_current_line()
                utils.telescope("find_files", { no_ignore = true, default_text = line })()
              end,
              ["<a-h>"] = function()
                local action_state = require "telescope.actions.state"
                local line = action_state.get_current_line()
                utils.telescope("find_files", { hidden = true, default_text = line })()
              end,

              ["<C-n>"] = actions.cycle_history_next,
              ["<C-p>"] = actions.cycle_history_prev,
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,

              ["<leader>e"] = function() end,
            },
            n = { q = actions.close },
          },
        },
      }
    end,
    config = require "plugins.configs.telescope",
  },
}
