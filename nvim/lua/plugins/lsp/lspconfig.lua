return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "folke/neoconf.nvim",
        opts = function()
          local global_settings, file_found
          local _, depth = vim.fn.stdpath("config"):gsub("/", "")
          for _, dir in ipairs(kickstart.supported_configs) do
            dir = dir .. "/lua/user"
            if vim.fn.isdirectory(dir) == 1 then
              local path = dir .. "/neoconf.json"
              if vim.fn.filereadable(path) == 1 then
                file_found = true
                global_settings = path
              elseif not file_found then
                global_settings = path
              end
            end
          end
          return { global_settings = global_settings and string.rep("../", depth):sub(1, -2) .. global_settings }
        end,
      },
      {
        "williamboman/mason-lspconfig.nvim",
        cmd = { "LspInstall", "LspUninstall" },
        opts = function(_, opts)
          if not opts.handlers then opts.handlers = {} end
          opts.handlers[1] = function(server) require("kickstart.utils.lsp").setup(server) end
        end,
        config = require "plugins.configs.mason.mason-lspconfig",
      },
    },
    cmd = function(_, cmds) -- HACK: lazy load lspconfig on `:Neoconf` if neoconf is available
      if require("kickstart.utils").is_available "neoconf.nvim" then table.insert(cmds, "Neoconf") end
    end,
    event = "User KickstartFile",
    config = require "plugins.configs.lsp.lspconfig",
  },

  {
    "jose-elias-alvarez/null-ls.nvim",
    dependencies = {
      {
        opts = { handlers = {} },
        "jay-babu/mason-null-ls.nvim",
        cmd = { "NullLsInstall", "NullLsUninstall" },
      },
    },
    event = "User KickstartFile",
    opts = function(_, config)
      local null_ls = require "null-ls"

      -- Check supported formatters and linters
      -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
      -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
      return {
        sources = {
          null_ls.builtins.formatting.stylua,
          null_ls.builtins.formatting.prettierd,
        },
        on_attach = require("kickstart.utils.lsp").on_attach,
      }
    end,
  },
}
