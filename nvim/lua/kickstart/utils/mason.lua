local M = {}

local utils = require "kickstart.utils"
local function mason_notify(msg, type) utils.notify(msg, type, { title = "Mason" }) end

local kickstartevent = utils.actions.event

--- Update all packages in Mason
function M.update_all()
	local registry_avail, registry = pcall(require, "mason-registry")
	if not registry_avail then
		vim.api.nvim_err_writeln "Unable to access mason registry"
		return
	end

	mason_notify "Checking for package updates..."
	registry.update(vim.schedule_wrap(function(success, updated_registries)
		if success then
			local installed_pkgs = registry.get_installed_packages()
			local running = #installed_pkgs
			local no_pkgs = running == 0

			if no_pkgs then
				mason_notify "No updates available"
				kickstartevent "MasonUpdateCompleted"
			else
				local updated = false
				for _, pkg in ipairs(installed_pkgs) do
					pkg:check_new_version(function(update_available, version)
						if update_available then
							updated = true
							mason_notify(("Updating `%s` to %s"):format(pkg.name, version.latest_version))
							pkg:install():on("closed", function()
								running = running - 1
								if running == 0 then
									mason_notify "Update Complete"
									kickstartevent "MasonUpdateCompleted"
								end
							end)
						else
							running = running - 1
							if running == 0 then
								if updated then
									mason_notify "Update Complete"
								else
									mason_notify "No updates available"
								end
								kickstartevent "MasonUpdateCompleted"
							end
						end
					end)
				end
			end
		else
			mason_notify(
				("Failed to update registries: %s"):format(updated_registries),
				vim.log.levels.ERROR
			)
		end
	end))
end

return M
