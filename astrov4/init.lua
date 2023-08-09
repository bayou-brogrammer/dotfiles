-- bootstrap
require("config.lazy")
-- run polish file at the very end
pcall(require, "config.polish")
