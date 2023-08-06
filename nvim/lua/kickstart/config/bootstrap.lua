_G.basenvim = {}

--- installation details from external installers
basenvim.install = _G["basenvim_installation"] or { home = vim.fn.stdpath "config" }
basenvim.supported_configs = { basenvim.install.home }

--- external basenvim configuration folder
basenvim.install.config = vim.fn.stdpath("config"):gsub("[^/\\]+$", "basenvim")

-- check if they are the same, protects against NVIM_APPNAME use for isolated install
if basenvim.install.home ~= basenvim.install.config then
	vim.opt.rtp:append(basenvim.install.config)
	--- supported basenvim user conifg folders
	table.insert(basenvim.supported_configs, basenvim.install.config)
end

--- Updater settings overridden with any user provided configuration
basenvim.updater = {
	options = { remote = "origin", channel = "stable" },
	snapshot = {
		module = "lazy_snapshot",
		path = vim.fn.stdpath "config" .. "/lua/lazy_snapshot.lua",
	},
	rollback_file = vim.fn.stdpath "cache" .. "/kickstartnvim_rollback.lua",
}

local options = basenvim.updater.options
if basenvim.install.is_stable ~= nil then
	options.channel = basenvim.install.is_stable and "stable" or "nightly"
end

if options.pin_plugins == nil then options.pin_plugins = options.channel == "stable" end

--- table of user created terminals
basenvim.user_terminals = {}
--- table of language servers to ignore the setup of, configured through lsp.skip_setup in the user configuration
basenvim.lsp = { skip_setup = {}, progress = {} }
--- the default colorscheme to apply on startup
basenvim.default_colorscheme = "astrotheme"
