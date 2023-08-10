-- AstroCore provides a central place to modify mappings set up as well as which-key menu titles
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreConfig
  opts = {
    mappings = {
      -- first key is the mode
      n = {
        w = false,
        e = false,
        f = false,
        b = false,

        --[[
          ############
          GENERAL
          ###########
        --]]
        ["<C-s>"] = { ":w!<cr>", desc = "Save File" }, -- change description but the same command
        ["<leader>gB"] = { ":GitBlameToggle<cr>", desc = "Toggle git Blame" }, -- change description but the same command

        --[[
          ############
          BUFFERS
          ###########
        --]]
        ["<leader>bD"] = {
          function()
            require("astroui.status.heirline").buffer_picker(function(bufnr)
              require("astrocore.buffer").close(bufnr)
            end)
          end,
          desc = "Pick to close",
        },

        -- tables with just a `desc` key will be registered with which-key if it's installed
        -- this is useful for naming menus
        ["<leader>b"] = { desc = "Buffers" },

        L = {
          function()
            require("astrocore.buffer").nav(vim.v.count > 0 and vim.v.count or 1)
          end,
          desc = "Next buffer",
        },
        H = {
          function()
            require("astrocore.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1))
          end,
          desc = "Previous buffer",
        },

        -- quick save
      },
      t = {
        -- setting a mapping to false will disable it
        -- ["<esc>"] = false,
      },
    },
  },
}
