--- ### KickstartNvim Updater
--
-- KickstartNvim Updater utilities to use within KickstartNvim
--
-- This module can also loaded with `local updater = require("kickstart.utils.updater")`
--

local git = require "kickstart.utils.git"
local utils = require "kickstart.utils"

local notify = utils.notify

--- Cancelled update message
local cancelled_message = { { "Update cancelled", "WarningMsg" } }

local function echo(messages)
	-- if no parameter provided, echo a new line
	messages = messages or { { "\n" } }
	if type(messages) == "table" then vim.api.nvim_echo(messages, false, {}) end
end

local function confirm_prompt(messages, type)
	return vim.fn.confirm(
		messages,
		"&Yes\n&No",
		(type == "Error" or type == "Warning") and 2 or 1,
		type or "Question"
	) == 1
end

local M = {}

--- Get the current KickstartNvim version
---@param quiet? boolean Whether to quietly execute or send a notification
---@return string # The current KickstartNvim version string
function M.version(quiet)
	local version = basenvim.install.version or git.current_version(false) or "unknown"
	if basenvim.updater.options.channel ~= "stable" then
		version = ("nightly (%s)"):format(version)
	end
	if version and not quiet then notify(("Version: *%s*"):format(version)) end
	return version
end

--- Get the full KickstartNvim changelog
---@param quiet? boolean Whether to quietly execute or display the changelog
---@return table # The current KickstartNvim changelog table of commit messages
function M.changelog(quiet)
	local summary = {}
	vim.list_extend(summary, git.pretty_changelog(git.get_commit_range()))
	if not quiet then echo(summary) end
	return summary
end

--- Sync Packer and then update Mason
function M.update_packages()
	require("lazy").sync { wait = true }
	require("kickstart.utils.mason").update_all()
end

--- KickstartNvim's rollback to saved previous version function
function M.rollback()
	local rollback_avail, rollback_opts = pcall(dofile, basenvim.updater.rollback_file)
	if not rollback_avail then
		notify("No rollback file available", vim.log.levels.ERROR)
		return
	end
	M.update(rollback_opts)
end

--- Attempt an update of KickstartNvim
---@param target string The target if checking out a specific tag or commit or nil if just pulling
local function attempt_update(target, opts)
	-- if updating to a new stable version or a specific commit checkout the provided target
	if opts.channel == "stable" or opts.commit then
		return git.checkout(target, false)
	-- if no target, pull the latest
	else
		return git.pull(false)
	end
end

--- Check if an update is available
---@param opts? table the settings to use for checking for an update
---@return table|boolean? # The information of an available update (`{ source = string, target = string }`), false if no update is available, or nil if there is an error
function M.update_available(opts)
	if not opts then opts = basenvim.updater.options end
	opts = require("kickstart.utils").extend_tbl({ remote = "origin" }, opts)

	-- if the git command is not available, then throw an error
	if not git.available() then
		notify(
			"`git` command is not available, please verify it is accessible in a command line. This may be an issue with your `PATH`",
			vim.log.levels.ERROR
		)
		return
	end

	-- if installed with an external package manager, disable the internal updater
	if not git.is_repo() then
		notify("Updater not available for non-git installations", vim.log.levels.ERROR)
		return
	end

	-- set up any remotes defined by the user if they do not exist
	for remote, entry in pairs(opts.remotes and opts.remotes or {}) do
		local url = git.parse_remote_url(entry)
		local current_url = git.remote_url(remote, false)
		local check_needed = false
		if not current_url then
			git.remote_add(remote, url)
			check_needed = true
		elseif
			current_url ~= url
			and confirm_prompt(
				("Remote %s is currently: %s\n" .. "Would you like us to set it to %s ?"):format(
					remote,
					current_url,
					url
				)
			)
		then
			git.remote_update(remote, url)
			check_needed = true
		end
		if check_needed and git.remote_url(remote, false) ~= url then
			vim.api.nvim_err_writeln("Error setting up remote " .. remote .. " to " .. url)
			return
		end
	end

	local is_stable = opts.channel == "stable"
	if is_stable then
		opts.branch = "main"
	elseif not opts.branch then
		opts.branch = "nightly"
	end

	-- setup branch if missing
	if not git.ref_verify(opts.remote .. "/" .. opts.branch, false) then
		git.remote_set_branches(opts.remote, opts.branch, false)
	end

	-- fetch the latest remote
	if not git.fetch(opts.remote) then
		vim.api.nvim_err_writeln("Error fetching remote: " .. opts.remote)
		return
	end

	-- switch to the necessary branch only if not on the stable channel
	if not is_stable then
		local local_branch = (opts.remote == "origin" and "" or (opts.remote .. "_")) .. opts.branch
		if git.current_branch() ~= local_branch then
			echo {
				{ "Switching to branch: " },
				{ opts.remote .. "/" .. opts.branch .. "\n\n", "String" },
			}
			if not git.checkout(local_branch, false) then
				git.checkout("-b " .. local_branch .. " " .. opts.remote .. "/" .. opts.branch, false)
			end
		end
		-- check if the branch was switched to successfully
		if git.current_branch() ~= local_branch then
			vim.api.nvim_err_writeln("Error checking out branch: " .. opts.remote .. "/" .. opts.branch)
			return
		end
	end

	local update = { source = git.local_head() }
	if is_stable then -- if stable get tag commit
		local version_search = opts.version or "latest"
		update.version = git.latest_version(git.get_versions(version_search))
		if not update.version then -- continue only if stable version is found
			vim.api.nvim_err_writeln("Error finding version: " .. version_search)
			return
		end
		update.target = git.tag_commit(update.version)
	elseif opts.commit then -- if commit specified use it
		update.target = git.branch_contains(opts.remote, opts.branch, opts.commit) and opts.commit
			or nil
	else -- get most recent commit
		update.target = git.remote_head(opts.remote, opts.branch)
	end

	if not update.source or not update.target then -- continue if current and target commits were found
		vim.api.nvim_err_writeln "Error checking for updates"
		return
	elseif update.source ~= update.target then
		-- update available
		return update
	else
		return false
	end
end

--- KickstartNvim's updater function
---@param opts? table the settings to use for the update
function M.update(opts)
	if not opts then opts = basenvim.updater.options end
	opts = require("kickstart.utils").extend_tbl(
		{ remote = "origin", show_changelog = true, sync_plugins = true, auto_quit = false },
		opts
	)

	local available_update = M.update_available(opts)
	if available_update == nil then
		return
	elseif not available_update then -- continue if current and target commits were found
		notify "No updates available"
	elseif -- prompt user if they want to accept update
		not opts.skip_prompts
		and not confirm_prompt(
			("Update available to %s\nUpdating requires a restart, continue?"):format(
				available_update.version or available_update.target
			)
		)
	then
		echo(cancelled_message)
		return
	else -- perform update
		local source, target = available_update.source, available_update.target
		M.create_rollback(true) -- create rollback file before updating

		-- calculate and print the changelog
		local changelog = git.get_commit_range(source, target)
		local breaking = git.breaking_changes(changelog)
		if
			#breaking > 0
			and not opts.skip_prompts
			and not confirm_prompt(
				("Update contains the following breaking changes:\n%s\nWould you like to continue?"):format(
					table.concat(breaking, "\n")
				),
				"Warning"
			)
		then
			echo(cancelled_message)
			return
		end
		-- attempt an update
		local updated = attempt_update(target, opts)
		-- check for local file conflicts and prompt user to continue or abort
		if
			not updated
			and not opts.skip_prompts
			and not confirm_prompt(
				"Unable to pull due to local modifications to base files.\nReset local files and continue?",
				"Error"
			)
		then
			echo(cancelled_message)
			return
		-- if continued and there were errors reset the base config and attempt another update
		elseif not updated then
			git.hard_reset(source)
			updated = attempt_update(target, opts)
		end
		-- if update was unsuccessful throw an error
		if not updated then
			vim.api.nvim_err_writeln "Error occurred performing update"
			return
		end
		-- print a summary of the update with the changelog
		local summary = {
			{ "KickstartNvim updated successfully to ", "Title" },
			{ git.current_version(), "String" },
			{ "!\n", "Title" },
			{
				opts.auto_quit and "KickstartNvim will now update plugins and quit.\n\n"
					or "After plugins update, please restart.\n\n",
				"WarningMsg",
			},
		}

		if opts.show_changelog and #changelog > 0 then
			vim.list_extend(summary, { { "Changelog:\n", "Title" } })
			vim.list_extend(summary, git.pretty_changelog(changelog))
		end
		echo(summary)

		-- if the user wants to auto quit, create an autocommand to quit KickstartNvim on the update completing
		if opts.auto_quit then
			vim.api.nvim_create_autocmd("User", {
				desc = "Auto quit KickstartNvim after update completes",
				pattern = "KickstartUpdateComplete",
				command = "quitall",
			})
		end

		require("lazy.core.plugin").load() -- force immediate reload of lazy
		if opts.sync_plugins then require("lazy").sync { wait = true } end
		utils.actions.event "UpdateComplete"
	end
end

return M
