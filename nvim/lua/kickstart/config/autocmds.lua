-- This file is automatically loaded by kickstart.config.init.

local utils = require "kickstart.utils"

local autocmd = vim.api.nvim_create_autocmd
local cmd = vim.api.nvim_create_user_command

local augroup = utils.helpers.augroup
local is_available = utils.is_available
local kickstartevent = utils.actions.event

-- ## EXTRA LOGIC -----------------------------------------------------------
-- 1. Events to load plugins faster → 'KickstartFile'/'KickstartGitFile':
--    this is pretty much the same thing as the event 'BufEnter',
--    but without increasing the startup time displayed in the greeter.
autocmd({ "BufReadPost", "BufNewFile", "BufWritePost" }, {
	desc = "Nvim user events for file detection (KickstartFile and KickstartGitFile)",
	group = augroup "file_user_events",
	callback = function(args)
		local empty_buffer = vim.fn.expand "%" == ""
		local greeter = vim.api.nvim_get_option_value("filetype", { buf = args.buf }) == "alpha"
		local git_repo = utils.actions.cmd({ "git", "-C", vim.fn.expand "%:p:h", "rev-parse" }, false)

		-- For any file exept empty buffer, or the greeter (alpha)
		if not (empty_buffer or greeter) then
			kickstartevent "File" -- Emit event 'KickstartFile'

			-- Is the buffer part of a git repo?
			if git_repo then
				kickstartevent "GitFile" -- Emit event 'KickstartGitFile'
				utils.helpers.del_augroup "file_user_events"
			end
		end
	end,
})

autocmd("BufReadPre", {
	desc = "Disable certain functionality on very large files",
	group = augroup "large_buf",
	callback = function(args)
		local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(args.buf))
		vim.b[args.buf].large_buf = (ok and stats and stats.size > vim.g.max_file.size)
			or vim.api.nvim_buf_line_count(args.buf) > vim.g.max_file.lines
	end,
})

local bufferline_group = augroup "bufferline"
autocmd({ "BufAdd", "BufEnter", "TabNewEntered" }, {
	desc = "Update buffers when adding new buffers",
	group = bufferline_group,
	callback = function(args)
		local buf_utils = require "kickstart.utils.buffer"
		if not vim.t.bufs then vim.t.bufs = {} end
		if not buf_utils.is_valid(args.buf) then return end
		if args.buf ~= buf_utils.current_buf then
			buf_utils.last_buf = buf_utils.is_valid(buf_utils.current_buf) and buf_utils.current_buf
				or nil
			buf_utils.current_buf = args.buf
		end
		local bufs = vim.t.bufs
		if not vim.tbl_contains(bufs, args.buf) then
			table.insert(bufs, args.buf)
			vim.t.bufs = bufs
		end
		vim.t.bufs = vim.tbl_filter(buf_utils.is_valid, vim.t.bufs)
		kickstartevent "BufsUpdated"
	end,
})

autocmd("BufDelete", {
	desc = "Update buffers when deleting buffers",
	group = bufferline_group,
	callback = function(args)
		local removed
		for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
			local bufs = vim.t[tab].bufs
			if bufs then
				for i, bufnr in ipairs(bufs) do
					if bufnr == args.buf then
						removed = true
						table.remove(bufs, i)
						vim.t[tab].bufs = bufs
						break
					end
				end
			end
		end
		vim.t.bufs = vim.tbl_filter(require("kickstart.utils.buffer").is_valid, vim.t.bufs)
		if removed then kickstartevent "BufsUpdated" end
		vim.cmd.redrawtabline()
	end,
})

-- Check if we need to reload the file when it changed
autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
	group = augroup "checktime",
	command = "checktime",
})

-- Highlight on yank
autocmd("TextYankPost", {
	group = augroup "highlight_yank",
	callback = function() vim.highlight.on_yank() end,
})

-- resize splits if window got resized
autocmd({ "VimResized" }, {
	group = augroup "resize_splits",
	callback = function() vim.cmd "tabdo wincmd =" end,
})

-- go to last loc when opening a buffer
autocmd("BufReadPost", {
	group = augroup "last_loc",
	callback = function()
		local exclude = { "gitcommit" }
		local buf = vim.api.nvim_get_current_buf()
		if vim.tbl_contains(exclude, vim.bo[buf].filetype) then return end
		local mark = vim.api.nvim_buf_get_mark(buf, '"')
		local lcount = vim.api.nvim_buf_line_count(buf)
		if mark[1] > 0 and mark[1] <= lcount then pcall(vim.api.nvim_win_set_cursor, 0, mark) end
	end,
})

-- close some filetypes with <q>
autocmd("FileType", {
	group = augroup "close_with_q",
	pattern = {
		"PlenaryTestPopup",
		"help",
		"lspinfo",
		"man",
		"notify",
		"qf",
		"spectre_panel",
		"startuptime",
		"tsplayground",
		"neotest-output",
		"checkhealth",
		"neotest-summary",
		"neotest-output-panel",
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
	end,
})

-- -- wrap and check for spell in text filetypes
-- autocmd("FileType", {
--   group = augroup("wrap_spell"),
--   pattern = { "gitcommit", "markdown" },
--   callback = function()
--     vim.opt_local.wrap = true
--     vim.opt_local.spell = true
--   end,
-- })

-- Auto create dir when saving a file, in case some intermediate directory does not exist
autocmd({ "BufWritePre" }, {
	group = augroup "auto_create_dir",
	callback = function(event)
		if event.match:match "^%w%w+://" then return end
		local file = vim.loop.fs_realpath(event.match) or event.match
		vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
	end,
})

-- 4. Hot reload on config change.
autocmd({ "BufWritePost" }, {
	desc = "When writing a buffer, :NvimReload if the buffer is a config file.",
	group = augroup "reload_if_buffer_is_config_file",
	callback = function()
		local filesThatTriggerReload = {
			vim.fn.stdpath "config" .. "lua/kickstart/config/options.lua",
			vim.fn.stdpath "config" .. "lua/kickstart/config/mappings.lua",
		}

		local bufPath = vim.fn.expand "%:p"
		for _, filePath in ipairs(filesThatTriggerReload) do
			if filePath == bufPath then vim.cmd "NvimReload" end
		end
	end,
})

if is_available "alpha-nvim" then
	autocmd({ "User", "BufEnter" }, {
		desc = "Disable status, tablines, and cmdheight for alpha",
		group = augroup "alpha_settings",
		callback = function(args)
			if
				(
					(args.event == "User" and args.file == "AlphaReady")
					or (
						args.event == "BufEnter"
						and vim.api.nvim_get_option_value("filetype", { buf = args.buf }) == "alpha"
					)
				) and not vim.g.before_alpha
			then
				vim.g.before_alpha = {
					showtabline = vim.opt.showtabline:get(),
					laststatus = vim.opt.laststatus:get(),
					cmdheight = vim.opt.cmdheight:get(),
				}
				vim.opt.showtabline, vim.opt.laststatus, vim.opt.cmdheight = 0, 0, 0
			elseif
				vim.g.before_alpha
				and args.event == "BufEnter"
				and vim.api.nvim_get_option_value("buftype", { buf = args.buf }) ~= "nofile"
			then
				vim.opt.laststatus, vim.opt.showtabline, vim.opt.cmdheight =
					vim.g.before_alpha.laststatus,
					vim.g.before_alpha.showtabline,
					vim.g.before_alpha.cmdheight
				vim.g.before_alpha = nil
			end
		end,
	})
	autocmd("VimEnter", {
		desc = "Start Alpha when vim is opened with no arguments",
		group = augroup "alpha_autostart",
		callback = function()
			local should_skip = false
			if vim.fn.argc() > 0 or vim.fn.line2byte(vim.fn.line "$") ~= -1 or not vim.o.modifiable then
				should_skip = true
			else
				for _, arg in pairs(vim.v.argv) do
					if arg == "-b" or arg == "-c" or vim.startswith(arg, "+") or arg == "-S" then
						should_skip = true
						break
					end
				end
			end
			if not should_skip then
				require("alpha").start(true, require("alpha").default_config)
				vim.schedule(function() vim.cmd.doautocmd "FileType" end)
			end
		end,
	})
end

if is_available "resession.nvim" then
	autocmd("VimLeavePre", {
		desc = "Save session on close",
		group = augroup "resession_auto_save",
		callback = function()
			local buf_utils = require "kickstart.utils.buffer"
			local autosave = buf_utils.sessions.autosave
			if autosave and buf_utils.is_valid_session() then
				local save = require("resession").save
				if autosave.last then save("Last Session", { notify = false }) end
				if autosave.cwd then save(vim.fn.getcwd(), { dir = "dirsession", notify = false }) end
			end
		end,
	})
end

autocmd("FileType", {
	desc = "Unlist quickfist buffers",
	group = augroup "unlist_quickfist",
	pattern = "qf",
	callback = function() vim.opt_local.buflisted = false end,
})

autocmd({ "VimEnter", "FileType", "BufEnter", "WinEnter" }, {
	desc = "URL Highlighting",
	group = augroup "highlighturl",
	callback = function() utils.set_url_match() end,
})

cmd(
	"KickstartChangelog",
	function() require("kickstart.utils.updater").changelog() end,
	{ desc = "Check KickstartNvim Changelog" }
)
cmd(
	"KickstartUpdatePackages",
	function() require("kickstart.utils.updater").update_packages() end,
	{ desc = "Update Plugins and Mason" }
)
cmd(
	"KickstartRollback",
	function() require("kickstart.utils.updater").rollback() end,
	{ desc = "Rollback KickstartNvim" }
)
cmd(
	"KickstartUpdate",
	function() require("kickstart.utils.updater").update() end,
	{ desc = "Update KickstartNvim" }
)
cmd(
	"KickstartVersion",
	function() require("kickstart.utils.updater").version() end,
	{ desc = "Check KickstartNvim Version" }
)
cmd(
	"KickstartReload",
	function() require("kickstart.utils").reload() end,
	{ desc = "Reload KickstartNvim (Experimental)" }
)
