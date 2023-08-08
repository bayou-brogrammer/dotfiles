-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
-- run polish file at the very end
pcall(require, "config.polish")
