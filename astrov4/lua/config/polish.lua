local lspconfig = require("lspconfig")

lspconfig.tsserver.setup({
  settings = {
    typescript = {
      inlayHints = {
        includeInlayVariableTypeHints = true,
        includeInlayParameterNameHints = "all",
        includeInlayEnumMemberValueHints = true,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayVariableTypeHintsWhenTypeMatchesName = false,
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
      },
    },
    javascript = {
      inlayHints = {
        includeInlayVariableTypeHints = true,
        includeInlayParameterNameHints = "all",
        includeInlayEnumMemberValueHints = true,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayVariableTypeHintsWhenTypeMatchesName = false,
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
      },
    },
  },
})
