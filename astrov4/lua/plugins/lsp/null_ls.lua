-- Exapmle customization of Null-LS sources
return {
  "jose-elias-alvarez/null-ls.nvim",
  dependencies = {
    { "AstroNvim/astrolsp", opts = {} },
  },
  opts = function(_, config)
    -- config variable is the default configuration table for the setup function call
    local null_ls = require("null-ls")

    -- Check supported formatters and linters
    -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
    -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
    config.sources = {
      -- Set a formatter
      null_ls.builtins.formatting.stylua,
      null_ls.builtins.formatting.prettierd,
    }

    config.on_attach = require("astrolsp").on_attach

    return config -- return final config table
  end,
}
