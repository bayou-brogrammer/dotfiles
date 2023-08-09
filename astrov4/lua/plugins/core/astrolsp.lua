return {
  "AstroNvim/astrolsp",
  lazy = false,
  priority = 10000, -- load astrolsp first
  ---@type AstroLSPConfig
  opts = {
    -- Configuration table of features provided by AstroLSP
    features = {
      autoformat = true, -- enable or disable auto formatting on start
      codelens = true, -- enable/disable codelens refresh on start
      diagnostics_mode = 3, -- diagnostic mode on start (0 = off, 1 = no signs/virtual text, 2 = no virtual text, 3 = off)
      inlay_hints = true, -- enable/disable inlay hints on start
      lsp_handlers = true, -- enable/disable setting of lsp_handlers
      semantic_tokens = true, -- enable/disable semantic token highlighting
    },
    -- Configure default capabilities for language servers (`:h vim.lsp.protocol.make_client.capabilities()`)
    capabilities = {
      textDocument = {
        foldingRange = { dynamicRegistration = false },
      },
    },
    -- Configure language servers for `lspconfig` (`:h lspconfig-setup`)
    config = {
      lua_ls = {
        settings = {
          Lua = {
            hint = { enable = true, arrayIndex = "Disable" },
          },
        },
      },
      clangd = {
        capabilities = {
          offsetEncoding = "utf-8",
        },
      },
    },
    -- Configure diagnostics options (`:h vim.diagnostic.config()`)
    diagnostics = {
      underline = true,
      virtual_text = true,
      update_in_insert = false,
    },
    -- A custom flags table to be passed to all language servers  (`:h lspconfig-setup`)
    flags = {
      exit_timeout = 5000,
    },
    -- Configuration options for controlling formatting with language servers
    formatting = {
      -- control auto formatting on save
      format_on_save = {
        -- enable or disable format on save globally
        enabled = true,
        allow_filetypes = {},
        -- disable format on save for specified filetypes
        ignore_filetypes = {
          "python",
        },
      },
      -- disable formatting capabilities for specific language servers
      disabled = { "lua_ls" },
      -- default format timeout
      timeout_ms = 1000,
      -- fully override the default formatting function
      filter = function(client)
        return true
      end,
    },
    -- Configure how language servers get set up
    handlers = {
      -- default handler, first entry with no key
      function(server, opts)
        require("lspconfig")[server].setup(opts)
      end,

      -- custom function handler for pyright
      pyright = function(_, opts)
        require("lspconfig").pyright.setup(opts)
      end,

      -- set to false to disable the setup of a language server
      rust_analyzer = true,
    },
    -- Configuration of mappings added when attaching a language server during the core `on_attach` function
    -- The first key into the table is the vim map mode (`:h map-modes`), and the value is a table of entries to be passed to `vim.keymap.set` (`:h vim.keymap.set`):
    --   - The key is the first parameter or the vim mode (only a single mode supported) and the value is a table of keymaps within that mode:
    --     - The first element with no key in the table is the action (the 2nd parameter) and the rest of the keys/value pairs are options for the third parameter.
    --       There is also a special `cond` key which can either be a string of a language server capability or a function with `client` and `bufnr` parameters that returns a boolean of whether or not the mapping is added.
    mappings = {
      -- map mode (:h map-modes)
      n = {
        -- a binding with no condition and therefore is always added
        gl = {
          function()
            vim.diagnostic.open_float()
          end,
          desc = "Hover diagnostics",
        },
        -- condition for only server with declaration capabilities
        gD = {
          function()
            vim.lsp.buf.declaration()
          end,
          desc = "Declaration of current symbol",
          cond = "textDocument/declaration",
        },
        -- condition with a full function with `client` and `bufnr`
        ["<leader>uY"] = {
          function()
            require("astrolsp.toggles").buffer_semantic_tokens()
          end,
          desc = "Toggle LSP semantic highlight (buffer)",
          cond = function(client, bufnr)
            return client.server_capabilities.semanticTokensProvider and vim.lsp.semantic_tokens
          end,
        },
      },
    },
    -- A list like table of servers that should be setup, useful for enabling language servers not installed with Mason.
    servers = { "dartls", "lua_ls", "tsserver", "ocamllsp" },
    -- A custom `on_attach` function to be run after the default `on_attach` function, takes two parameters `client` and `bufnr`  (`:h lspconfig-setup`)
    on_attach = function(client, bufnr)
      -- TODO: Do we need this?
      -- client.server_capabilities.semanticTokensProvider = false
    end,
  },
}
