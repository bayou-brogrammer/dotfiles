--- ### Nvim buffer utils
--
--  DESCRIPTION:
--  These are are the buffer options you see when pressing <leader>b.
--
--  While you could technically delete this file, we encourage you to keep it,
--  as it takes a lot of complexity out of '../4-mappings.lua'.

local M = {}

--- HELPERS -----------------------------------------------------------------
M.comparator = {}

--- FUNCTIONS ---------------------------------------------------------------

--- Move the current buffer tab n places in the bufferline.
---@param n number The number of tabs to move the current buffer over
---                by (positive = right, negative = left)
function M.move(n)
  if n == 0 then return end                         -- if n = 0 then no shifts are needed
  local bufs = vim.t.bufs                           -- make temp variable

  for i, bufnr in ipairs(bufs) do                   -- loop to find current buffer
    if bufnr == vim.api.nvim_get_current_buf() then -- found index of current buffer
      for _ = 0, (n % #bufs) - 1 do                 -- calculate number of right shifts
        local new_i = i + 1                         -- get next i
        if i == #bufs then                          -- if at end, cycle to beginning
          new_i = 1                                 -- next i is actually 1 if at the end
          local val = bufs[i]                       -- save value
          table.remove(bufs, i)                     -- remove from end
          table.insert(bufs, new_i, val)            -- insert at beginning
        else                                        -- if not at the end,then just do an in place swap
          bufs[i], bufs[new_i] = bufs[new_i], bufs[i]
        end
        i = new_i -- iterate i to next value
      end
      break
    end
  end

  vim.t.bufs = bufs       -- set buffers
  require("base.utils").event "BufsUpdated"
  vim.cmd.redrawtabline() -- redraw tabline
end

--- Navigate left and right by n places in the bufferline.
-- @param n number The number of tabs to navigate to (positive = right, negative = left).
function M.nav(n)
  local current = vim.api.nvim_get_current_buf()
  for i, v in ipairs(vim.t.bufs) do
    if current == v then
      vim.cmd.b(vim.t.bufs[(i + n - 1) % #vim.t.bufs + 1])
      break
    end
  end
end

--- Close all buffers.
---@param keep_current? boolean Whether or not to keep the current buffer
---                             (default: false).
---@param force? boolean Whether or not to foce close the buffers
---                      or confirm changes (default: false).
function M.close_all(keep_current, force)
  if keep_current == nil then keep_current = false end
  local current = vim.api.nvim_get_current_buf()
  for _, bufnr in ipairs(vim.t.bufs) do
    if not keep_current or bufnr ~= current then M.close(bufnr, force) end
  end
end

--- Check if a buffer is valid.
---@param bufnr number The buffer to check.
---@return boolean # Whether the buffer is valid or not.
function M.is_valid(bufnr)
  if not bufnr then bufnr = 0 end
  return vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].buflisted
end

return M
