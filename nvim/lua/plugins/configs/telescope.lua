return function(_, opts)
  local telescope = require "telescope"
  telescope.setup(opts)

  local utils = require "kickstart.utils"
  local conditional_func = utils.conditional_func
  conditional_func(telescope.load_extension, pcall(require, "notify"), "notify")
  conditional_func(telescope.load_extension, pcall(require, "telescope"), "file_browser")
  conditional_func(telescope.load_extension, utils.is_available "auto-session", "session-lens")
  conditional_func(telescope.load_extension, utils.is_available "telescope-fzf-native.nvim", "fzf")
end
