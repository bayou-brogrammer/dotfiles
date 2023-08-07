return function(_, opts)
  require("mason-lspconfig").setup(opts)
  require("kickstart.utils").event "MasonLspSetup"
end
