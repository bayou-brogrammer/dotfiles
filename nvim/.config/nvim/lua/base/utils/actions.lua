local M = {}

--- Merge extended options with a default table of options
---@param default? table The default table that you want to merge into
---@param opts? table The new options that should be merged with the default table
---@return table # The merged table
function M.extend_tbl(default, opts)
  opts = opts or {}
  return default and vim.tbl_deep_extend("force", default, opts) or opts
end

--- Toggle a user terminal if it exists, if not then create a new one and save it.
---@param opts string|table A terminal command string or a table of options
---                         for Terminal:new() Check toggleterm.nvim
---                         documentation for table format.
function M.toggle_term_cmd(opts)
  local terms = {}

  -- if a command string is provided, create a table for Terminal:new() options
  if type(opts) == "string" then opts = { cmd = opts, hidden = true } end
  local num = vim.v.count > 0 and vim.v.count or 1

  -- if terminal doesn't exist yet, create it
  if not terms[opts.cmd] then terms[opts.cmd] = {} end

  if not terms[opts.cmd][num] then
    if not opts.count then opts.count = vim.tbl_count(terms) * 100 + num end
    if not opts.on_exit then
      opts.on_exit = function() terms[opts.cmd][num] = nil end
    end
    terms[opts.cmd][num] = require("toggleterm.terminal").Terminal:new(opts)
  end

  -- toggle the terminal
  terms[opts.cmd][num]:toggle()
end

--- Serve a notification with a title of Nvim.
---@param msg string The notification body.
---@param type number|nil The type of the notification (:help vim.log.levels).
---@param opts? table The nvim-notify options to use (:help notify-options).
function M.notify(msg, type, opts)
  vim.schedule(function()
    vim.notify(
      msg, type, M.extend_tbl({ title = "Nvim" }, opts))
  end)
end

--- Add syntax matching rules for highlighting URLs/URIs.
function M.set_url_effect()
  M.delete_url_effect()
  if vim.g.highlighturl_enabled then
    vim.fn.matchadd("HighlightURL", M.url_matcher, 15)
  end
end

return M
