-- Autocmds file.
--
-- DESCRIPTION:
-- All autocmds are defined here.

local autocmd = vim.api.nvim_create_autocmd
local cmd = vim.api.nvim_create_user_command

local utils = require "base.utils"
local actions = require "base.utils.actions"
local is_available = utils.is_available

local function augroup(name)
  return vim.api.nvim_create_augroup("yvim_" .. name, { clear = true })
end

-- ## EXTRA LOGIC -----------------------------------------------------------
-- 1. Events to load plugins faster → 'BaseFile'/'BaseGitFile':
--    this is pretty much the same thing as the event 'BufEnter',
--    but without increasing the startup time displayed in the greeter.
autocmd({ "BufReadPost", "BufNewFile", "BufWritePost" }, {
  desc = "Nvim user events for file detection (BaseFile and BaseGitFile)",
  group = augroup("file_user_events"),
  callback = function(args)
    local empty_buffer = vim.fn.expand "%" == ""
    local greeter = vim.api.nvim_get_option_value("filetype", { buf = args.buf }) == "alpha"
    local git_repo = utils.cmd({ "git", "-C", vim.fn.expand "%:p:h", "rev-parse" }, false)

    -- For any file exept empty buffer, or the greeter (alpha)
    if not (empty_buffer or greeter) then
      utils.event "File" -- Emit event 'BaseFile'

      -- Is the buffer part of a git repo?
      if git_repo then
        utils.event "GitFile" -- Emit event 'BaseGitFile'
        vim.api.nvim_del_augroup_by_name "file_user_events"
      end
    end
  end,
})

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime"),
  command = "checktime",
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
  group = augroup("resize_splits"),
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("last_loc"),
  callback = function()
    local exclude = { "gitcommit" }
    local buf = vim.api.nvim_get_current_buf()
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) then
      return
    end
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q"),
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

-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("wrap_spell"),
  pattern = { "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- -- Auto create dir when saving a file, in case some intermediate directory does not exist
-- vim.api.nvim_create_autocmd({ "BufWritePre" }, {
--   group = augroup("auto_create_dir"),
--   callback = function(event)
--     if event.match:match("^%w%w+://") then
--       return
--     end
--     local file = vim.loop.fs_realpath(event.match) or event.match
--     vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
--   end,
-- })

-- Hot reload on config change.
autocmd({ "BufWritePost" }, {
  desc = "When writing a buffer, :NvimReload if the buffer is a config file.",
  group = augroup("reload_if_buffer_is_config_file"),
  callback = function()
    local filesThatTriggerReload = {
      vim.fn.stdpath "config" .. "lua/base/1-options.lua",
      vim.fn.stdpath "config" .. "lua/base/4-mappings.lua",
    }

    local bufPath = vim.fn.expand "%:p"
    for _, filePath in ipairs(filesThatTriggerReload) do
      if filePath == bufPath then vim.cmd "NvimReload" end
    end
  end,
})

-- ## COOL HACKS ------------------------------------------------------------
--  Effect: URL underline.
autocmd({ "VimEnter", "FileType", "BufEnter", "WinEnter" }, {
  desc = "URL Highlighting",
  group = augroup("HighlightUrl"),
  callback = function() actions.set_url_effect() end,
})

-- ## COMMANDS --------------------------------------------------------------
-- 10. Nvim updater commands
cmd(
  "NvimChangelog",
  function() require("base.utils.updater").changelog() end,
  { desc = "Check Nvim Changelog" }
)
cmd(
  "NvimUpdatePlugins",
  function() require("base.utils.updater").update_packages() end,
  { desc = "Update Plugins and Mason" }
)
cmd(
  "NvimRollbackCreate",
  function() require("base.utils.updater").create_rollback(true) end,
  { desc = "Create a rollback of '~/.config/nvim'." }
)
cmd(
  "NvimRollbackRestore",
  function() require("base.utils.updater").rollback() end,
  { desc = "Restores '~/.config/nvim' to the last rollbacked state." }
)
cmd(
  "NvimFreezePluginVersions",
  function() require("base.utils.updater").generate_snapshot(true) end,
  { desc = "Lock package versions (only lazy, not mason)." }
)
cmd(
  "NvimUpdateConfig", function() require("base.utils.updater").update() end,
  { desc = "Update Nvim distro" }
)
cmd(
  "NvimVersion",
  function() require("base.utils.updater").version() end,
  { desc = "Check Nvim distro Version" }
)
cmd(
  "NvimReload",
  function() require("base.utils").reload() end,
  { desc = "Reload Nvim without closing it (Experimental)" }
)

-- Extra commands
----------------------------------------------

-- Change working directory
cmd("Cwd", function()
  vim.cmd ":cd %:p:h"
  vim.cmd ":pwd"
end, { desc = "cd current file's directory" })

-- Set working directory (alias)
cmd("Swd", function()
  vim.cmd ":cd %:p:h"
  vim.cmd ":pwd"
end, { desc = "cd current file's directory" })
