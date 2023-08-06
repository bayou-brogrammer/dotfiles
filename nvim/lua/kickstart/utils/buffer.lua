--- ### KickstartNvim Buffer Utilities
--
-- Buffer management related utility functions
--

local M = {}

local utils = require "kickstart.utils"

--- Placeholders for keeping track of most recent and previous buffer
M.current_buf, M.last_buf = nil, nil

-- TODO: Add user configuration table for this once resession is default
--- Configuration table for controlling session options
M.sessions = {
	autosave = {
		last = true, -- auto save last session
		cwd = true, -- auto save session for each working directory
	},
	ignore = {
		dirs = {}, -- working directories to ignore sessions in
		filetypes = { "gitcommit", "gitrebase" }, -- filetypes to ignore sessions
		buftypes = {}, -- buffer types to ignore sessions
	},
}

--[[
========================================
==      Validity         
========================================
--]]

--- Check if a buffer is valid
---@param bufnr number? The buffer to check, default to current buffer
---@return boolean # Whether the buffer is valid or not
function M.is_valid(bufnr)
	if not bufnr then bufnr = 0 end
	return vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].buflisted
end

--- Check if the current buffers form a valid session
---@return boolean # Whether the current session of buffers is a valid session
function M.is_valid_session()
	local cwd = vim.fn.getcwd()
	for _, dir in ipairs(M.sessions.ignore.dirs) do
		if vim.fn.expand(dir) == cwd then return false end
	end

	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		if M.is_restorable(bufnr) then return true end
	end

	return false
end

--[[
========================================
==      MISC         
========================================
--]]

--- Check if a buffer can be restored
---@param bufnr number The buffer to check
---@return boolean # Whether the buffer is restorable or not
function M.is_restorable(bufnr)
	if not M.is_valid(bufnr) or vim.api.nvim_get_option_value("bufhidden", { buf = bufnr }) ~= "" then
		return false
	end

	local buftype = vim.api.nvim_get_option_value("buftype", { buf = bufnr })
	if buftype == "" then
		-- Normal buffer, check if it listed.
		if not vim.api.nvim_get_option_value("buflisted", { buf = bufnr }) then return false end
		-- Check if it has a filename.
		if vim.api.nvim_buf_get_name(bufnr) == "" then return false end
	end

	if
		vim.tbl_contains(
			M.sessions.ignore.filetypes,
			vim.api.nvim_get_option_value("filetype", { buf = bufnr })
		)
		or vim.tbl_contains(
			M.sessions.ignore.buftypes,
			vim.api.nvim_get_option_value("buftype", { buf = bufnr })
		)
	then
		return false
	end
	return true
end

return M
