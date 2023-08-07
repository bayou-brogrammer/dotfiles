return function(_, opts)
  -- close Lazy and re-open when the dashboard is ready
  if vim.o.filetype == "lazy" then
    vim.cmd.close()
    vim.api.nvim_create_autocmd("User", {
      pattern = "AlphaReady",
      callback = function() require("lazy").show() end,
    })
  end

  require("alpha").setup(opts.config)

  vim.api.nvim_create_autocmd("User", {
    pattern = "KickstartNVimStarted",
    desc = "Add Alpha dashboard footer",
    once = true,
    callback = function()
      local stats = require("lazy").stats()
      local ms = math.floor(stats.startuptime * 100 + 0.5) / 100
      opts.section.footer.val =
        { " ", " ", " ", "⚡ KickstartNvim loaded " .. stats.count .. " plugins  in " .. ms .. "ms" }
      opts.section.footer.opts.hl = "DashboardFooter"
      pcall(vim.cmd.AlphaRedraw)
    end,
  })
end
