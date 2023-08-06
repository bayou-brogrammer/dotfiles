local M = {}

--- Run a shell command and capture the output and if the command
--- succeeded or failed
---@param cmd string | table The terminal command to execute
---@param show_error? boolean Whether or not to show an unsuccessful command
---                           as an error to the user
---@return string|nil # The result of a successfully executed command or nil
function M.cmd(cmd, show_error)
	if type(cmd) == "string" then cmd = vim.split(cmd, " ") end
	if vim.fn.has "win32" == 1 then cmd = vim.list_extend({ "cmd.exe", "/C" }, cmd) end

	local result = vim.fn.system(cmd)
	local success = vim.api.nvim_get_vvar "shell_error" == 0
	if not success and (show_error == nil or show_error) then
		vim.api.nvim_err_writeln(
			("Error running command %s\nError message:\n%s"):format(table.concat(cmd, " "), result)
		)
	end
	return success and result:gsub("[\27\155][][()#;?%d]*[A-PRZcf-ntqry=><~]", "") or nil
end

--- Trigger an KickstartNvim user event
---@param event string The event name to be appended to Kickstart
---@param delay? boolean Whether or not to delay the event asynchronously (Default: true)
function M.event(event, delay)
	local emit_event = function()
		vim.api.nvim_exec_autocmds("User", { pattern = "Kickstart" .. event, modeline = false })
	end

	if delay == false then
		emit_event()
	else
		vim.schedule(emit_event)
	end
end

return M
