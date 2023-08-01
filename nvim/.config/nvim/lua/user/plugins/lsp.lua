return {
  -- {
  --   "lvimuser/lsp-inlayhints.nvim",
  --   init = function()
  --     vim.api.nvim_create_autocmd("LspAttach", {
  --       group = vim.api.nvim_create_augroup("LspAttach_inlayhints", {}),
  --       callback = function(args)
  --         if not (args.data and args.data.client_id) then return end
  --         local client = vim.lsp.get_client_by_id(args.data.client_id)
  --         if client.server_capabilities.inlayHintProvider then
  --           local inlayhints = require "lsp-inlayhints"
  --           inlayhints.on_attach(client, args.buf)
  --           require("astronvim.utils").set_mappings({
  --             n = {
  --               ["<leader>uH"] = { inlayhints.toggle, desc = "Toggle inlay hints" },
  --             },
  --           }, { buffer = args.buf })
  --         end
  --       end,
  --     })
  --   end,
  --   opts = {},
  --   config = function()
  --     local lspconfig = require "lspconfig"
  --     lspconfig.tsserver.setup({
  --       settings = {
  --         typescript = {
  --           inlayHints = {
  --             includeInlayVariableTypeHints = true,
  --             includeInlayParameterNameHints = 'all',
  --             includeInlayEnumMemberValueHints = true,
  --             includeInlayFunctionParameterTypeHints = true,
  --             includeInlayFunctionLikeReturnTypeHints = true,
  --             includeInlayPropertyDeclarationTypeHints = true,
  --             includeInlayVariableTypeHintsWhenTypeMatchesName = false,
  --             includeInlayParameterNameHintsWhenArgumentMatchesName = false,
  --           }
  --         },
  --         javascript = {
  --           inlayHints = {
  --             includeInlayVariableTypeHints = true,
  --             includeInlayParameterNameHints = 'all',
  --             includeInlayEnumMemberValueHints = true,
  --             includeInlayFunctionParameterTypeHints = true,
  --             includeInlayFunctionLikeReturnTypeHints = true,
  --             includeInlayPropertyDeclarationTypeHints = true,
  --             includeInlayVariableTypeHintsWhenTypeMatchesName = false,
  --             includeInlayParameterNameHintsWhenArgumentMatchesName = false,
  --           }
  --         }
  --       }
  --     })
  --   end
  -- },
  {
    "p00f/clangd_extensions.nvim",
    optional = true,
    opts = { extensions = { autoSetHints = true } },
  },
  {
    "simrat39/rust-tools.nvim",
    optional = true,
    opts = { tools = { inlay_hints = { auto = true } } },
  },
}
