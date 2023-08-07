if vim.loader and vim.fn.has "nvim-0.9.1" == 1 then vim.loader.enable() end

local function source()
  for _, source in ipairs {
    "kickstart.config.bootstrap",
    "kickstart.config.options",
    "kickstart.config.lazy",
    "kickstart.config.autocmds",
    "kickstart.config.mappings",
  } do
    local status_ok, fault = pcall(require, source)
    if not status_ok then vim.api.nvim_err_writeln("Failed to load " .. source .. "\n\n" .. fault) end
  end

  if kickstart.default_colorscheme then
    if not pcall(vim.cmd.colorscheme, kickstart.default_colorscheme) then
      require("kickstart.utils").notify(
        ("Error setting up colorscheme: `%s`"):format(kickstart.default_colorscheme),
        vim.log.levels.ERROR
      )
    end
  end
end

if vim.fn.argc(-1) == 0 then
  -- autocmds and keymaps can wait to load
  vim.api.nvim_create_autocmd("User", {
    group = vim.api.nvim_create_augroup("LazyVim", { clear = true }),
    pattern = "VeryLazy",
    callback = function() source() end,
  })
else
  source()
end
