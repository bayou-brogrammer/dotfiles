return function(_, opts)
  require("which-key").setup(opts)
  require("kickstart.utils").which_key_register()
end
