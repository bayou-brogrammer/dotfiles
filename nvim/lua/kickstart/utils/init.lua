local M = {}

M.actions = require "kickstart.utils.actions"
M.buffer = require "kickstart.utils.buffer"
M.git = require "kickstart.utils.git"
M.helpers = require "kickstart.utils.helpers"
M.mason = require "kickstart.utils.mason"
M.ui = require "kickstart.utils.ui"
M.updater = require "kickstart.utils.updater"

--[[
========================================
==      Alias         
========================================
--]]

M.augroup = M.helpers.augroup
M.get_icon = M.helpers.get_icon
M.del_augroup = M.helpers.del_augroup
M.is_available = M.helpers.is_available

--[[
========================================
==      LOADS         
========================================
--]]

---@param fn fun()
function M.on_very_lazy(fn)
	vim.api.nvim_create_autocmd("User", {
		pattern = "VeryLazy",
		callback = function() fn() end,
	})
end

---@param name string
---@param fn fun(name:string)
function M.on_load(name, fn)
	local Config = require "lazy.core.config"
	if Config.plugins[name] and Config.plugins[name]._.loaded then
		vim.schedule(function() fn(name) end)
	else
		vim.api.nvim_create_autocmd("User", {
			pattern = "LazyLoad",
			callback = function(event)
				if event.data == name then
					fn(name)
					return true
				end
			end,
		})
	end
end

--[[
========================================
==      KEYMAPS         
========================================
--]]

--- Register queued which-key mappings
function M.which_key_register()
	if M.which_key_queue then
		local wk_avail, wk = pcall(require, "which-key")
		if wk_avail then
			for mode, registration in pairs(M.which_key_queue) do
				wk.register(registration, { mode = mode })
			end
			M.which_key_queue = nil
		end
	end
end

--- Get an empty table of mappings with a key for each map mode
---@return table<string,table> # a table with entries for each map mode
function M.empty_map_table()
	local maps = {}
	for _, mode in ipairs { "", "n", "v", "x", "s", "o", "!", "i", "l", "c", "t" } do
		maps[mode] = {}
	end
	if vim.fn.has "nvim-0.10.0" == 1 then
		for _, abbr_mode in ipairs { "ia", "ca", "!a" } do
			maps[abbr_mode] = {}
		end
	end
	return maps
end

--- Table based API for setting keybindings
---@param map_table table A nested table where the first key is the vim mode, the second key is the key to map, and the value is the function to set the mapping to
---@param base? table A base set of options to set on every keybinding
function M.set_mappings(map_table, base)
	-- iterate over the first keys for each mode
	base = base or {}
	for mode, maps in pairs(map_table) do
		-- iterate over each keybinding set in the current mode
		for keymap, options in pairs(maps) do
			-- build the options for the command accordingly
			if options then
				local cmd = options
				local keymap_opts = base
				if type(options) == "table" then
					cmd = options[1]
					keymap_opts = vim.tbl_deep_extend("force", keymap_opts, options)
					keymap_opts[1] = nil
				end
				if not cmd or keymap_opts.name then -- if which-key mapping, queue it
					if not keymap_opts.name then keymap_opts.name = keymap_opts.desc end
					if not M.which_key_queue then M.which_key_queue = {} end
					if not M.which_key_queue[mode] then M.which_key_queue[mode] = {} end
					M.which_key_queue[mode][keymap] = keymap_opts
				else -- if not which-key mapping, set it
					vim.keymap.set(mode, keymap, cmd, keymap_opts)
				end
			end
		end
	end
	if package.loaded["which-key"] then M.which_key_register() end -- if which-key is loaded already, register
end

--[[
========================================
==      NOTIFY         
========================================
--]]

--- Serve a notification with a title of KickstartNvim
---@param msg string The notification body
---@param type? number The type of the notification (:help vim.log.levels)
---@param opts? table The nvim-notify options to use (:help notify-options)
function M.notify(msg, type, opts)
	vim.schedule(
		function() vim.notify(msg, type, M.extend_tbl({ title = "KickstartNvim" }, opts)) end
	)
end

-- delay notifications till vim.notify was replaced or after 500ms
function M.lazy_notify()
	local notifs = {}
	local function temp(...) table.insert(notifs, vim.F.pack_len(...)) end

	local orig = vim.notify
	vim.notify = temp

	local timer = vim.loop.new_timer()
	local check = vim.loop.new_check()

	local replay = function()
		timer:stop()
		check:stop()
		if vim.notify == temp then
			vim.notify = orig -- put back the original notify if needed
		end
		vim.schedule(function()
			---@diagnostic disable-next-line: no-unknown
			for _, notif in ipairs(notifs) do
				vim.notify(vim.F.unpack_len(notif))
			end
		end)
	end

	-- wait till vim.notify has been replaced
	check:start(function()
		if vim.notify ~= temp then replay() end
	end)
	-- or if it took more than 500ms, then something went wrong
	timer:start(500, 0, replay)
end

--[[
========================================
==      MISC         
========================================
--]]

--- Merge extended options with a default table of options
---@param default? table The default table that you want to merge into
---@param opts? table The new options that should be merged with the default table
---@return table # The merged table
function M.extend_tbl(default, opts)
	opts = opts or {}
	return default and vim.tbl_deep_extend("force", default, opts) or opts
end

function M.fg(name)
	---@type {foreground?:number}?
	local hl = vim.api.nvim_get_hl and vim.api.nvim_get_hl(0, { name = name })
		or vim.api.nvim_get_hl_by_name(name, true)
	---@diagnostic disable-next-line: undefined-field, need-check-nil
	local fg = hl and hl.fg or hl.foreground
	return fg and { fg = string.format("#%06x", fg) }
end

--- Partially reload KickstartNvim settings. Includes core vim options, mappings, and highlights. This is an experimental feature and may lead to instabilities until restart.
---@param quiet? boolean Whether or not to notify on completion of reloading
---@return boolean # True if the reload was successful, False otherwise
function M.reload(quiet)
	local was_modifiable = vim.opt.modifiable:get()
	if not was_modifiable then vim.opt.modifiable = true end
	local core_modules =
		{ "kickstart.config.bootstrap", "kickstart.config.options", "kickstart.config.mappings" }

	vim.tbl_map(require("plenary.reload").reload_module, core_modules)

	local success = true
	for _, module in ipairs(core_modules) do
		local status_ok, fault = pcall(require, module)
		if not status_ok then
			vim.api.nvim_err_writeln("Failed to load " .. module .. "\n\n" .. fault)
			success = false
		end
	end

	if not was_modifiable then vim.opt.modifiable = false end
	if not quiet then -- if not quiet, then notify of result
		if success then
			M.notify("KickstartNvim successfully reloaded", vim.log.levels.INFO)
		else
			M.notify("Error reloading KickstartNvim...", vim.log.levels.ERROR)
		end
	end

	-- vim.cmd.doautocmd "ColorScheme"

	return success
end

--- regex used for matching a valid URL/URI string
M.url_matcher =
	"\\v\\c%(%(h?ttps?|ftp|file|ssh|git)://|[a-z]+[@][a-z]+[.][a-z]+:)%([&:#*@~%_\\-=?!+;/0-9a-z]+%(%([.;/?]|[.][.]+)[&:#*@~%_\\-=?!+/0-9a-z]+|:\\d+|,%(%(%(h?ttps?|ftp|file|ssh|git)://|[a-z]+[@][a-z]+[.][a-z]+:)@![0-9a-z]+))*|\\([&:#*@~%_\\-=?!+;/.0-9a-z]*\\)|\\[[&:#*@~%_\\-=?!+;/.0-9a-z]*\\]|\\{%([&:#*@~%_\\-=?!+;/.0-9a-z]*|\\{[&:#*@~%_\\-=?!+;/.0-9a-z]*})\\})+"

--- Delete the syntax matching rules for URLs/URIs if set
function M.delete_url_match()
	for _, match in ipairs(vim.fn.getmatches()) do
		if match.group == "HighlightURL" then vim.fn.matchdelete(match.id) end
	end
end

--- Add syntax matching rules for highlighting URLs/URIs
function M.set_url_match()
	M.delete_url_match()
	if vim.g.highlighturl_enabled then vim.fn.matchadd("HighlightURL", M.url_matcher, 15) end
end

return M
