local M = {}

---@param plugin string
function M.is_available(plugin) return require("lazy.core.config").spec.plugins[plugin] ~= nil end

--- Set an augroup by name
---@param name string
function M.augroup(name) return vim.api.nvim_create_augroup(name, { clear = true }) end

--- Delete an augroup by name
---@param name string
function M.del_augroup(name) vim.api.nvim_del_augroup_by_name(name) end

--- Get an icon from the KickstartNvim internal icons if it is available and return it
---@param kind string The kind of icon in kickstartnvim.icons to retrieve
---@param padding? integer Padding to add to the end of the icon
---@param no_fallback? boolean Whether or not to disable fallback to text icon
---@return string icon
function M.get_icon(kind, padding, no_fallback)
	if not vim.g.icons_enabled and no_fallback then return "" end
	local icon_pack = vim.g.icons_enabled and "icons" or "text_icons"

	if not M[icon_pack] then
		M.icons = require "kickstart.icons.nerd_font"
		M.text_icons = require "kickstart.icons.text"
	end

	local icon = M[icon_pack] and M[icon_pack][kind]
	return icon and icon .. string.rep(" ", padding or 0) or ""
end

return M
