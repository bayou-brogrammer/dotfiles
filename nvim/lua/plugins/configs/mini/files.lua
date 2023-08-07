return function(_, opts)
  require("kickstart.utils").notify(opts)

  require("mini.files").setup(opts.config)
end
