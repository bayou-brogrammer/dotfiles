local git = { url = "https://github.com/" }

--- Check if the KickstarNvim is able to reach the `git` command
---@return boolean # The result of running `git --help`
function git.available() return vim.fn.executable "git" == 1 end

--- Check the git client version number
---@return table|nil # A table with version information or nil if there is an error
function git.git_version()
	local output = git.cmd({ "--version" }, false)
	if output then
		local version_str = output:match "%d+%.%d+%.%d"
		local major, min, patch = unpack(vim.tbl_map(tonumber, vim.split(version_str, "%.")))
		return { major = major, min = min, patch = patch, str = version_str }
	end
end

--- Run a git command from the BaseNvim installation directory
---@param args string|string[] the git arguments
---@return string|nil # The result of the command or nil if unsuccessful
function git.cmd(args, ...)
	if type(args) == "string" then args = { args } end
	return require("kickstart.utils.actions").cmd(
		vim.list_extend({ "git", "-C", basenvim.install.home }, args),
		...
	)
end

--- Get the commit log between two commit hashes
---@param start_hash? string the start commit hash
---@param end_hash? string the end commit hash
---@return string[] # An array like table of commit messages
function git.get_commit_range(start_hash, end_hash, ...)
	local range = start_hash and end_hash and start_hash .. ".." .. end_hash or nil
	local log = git.cmd({ "log", "--no-merges", '--pretty="format:[%h] %s"', range }, ...)
	return log and vim.fn.split(log, "\n") or {}
end

--- Generate a table of commit messages for neovim's echo API with highlighting
---@param commits string[] an array like table of commit messages
---@return string[][] # An array like table of echo messages to provide to nvim_echo or kickstartnvim.echo
function git.pretty_changelog(commits)
	local changelog = {}
	for _, commit in ipairs(commits) do
		local hash, type, msg = commit:match "(%[.*%])(.*:)(.*)"
		if hash and type and msg then
			vim.list_extend(changelog, {
				{ hash, "DiffText" },
				{ type, git.is_breaking(commit) and "DiffDelete" or "DiffChange" },
				{ msg },
				{ "\n" },
			})
		end
	end
	return changelog
end

return git
