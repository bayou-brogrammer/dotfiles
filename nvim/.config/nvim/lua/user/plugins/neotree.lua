return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    source_selector = {
      winbar = false,
      statusline = false,
    },
    filesystem = {
      hijack_netrw_behavior = nil,
      use_libuv_file_watcher = true,
      filtered_items = {
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_hidden = false,
        hide_by_pattern = {
          "**/.git",
          "**/.DS_Store",
          "**/node_modules",
          "**/target",
        },
      },
      window = {
        mappings = {
          ["h"] = function(state)
            local node = state.tree:get_node()
            if node.type == "directory" and node:is_expanded() then
              require("neo-tree.sources.filesystem").toggle_directory(state, node)
            else
              require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
            end
          end,
          ["l"] = function(state)
            local node = state.tree:get_node()
            if node.type == "directory" then
              if not node:is_expanded() then
                require("neo-tree.sources.filesystem").toggle_directory(state, node)
              elseif node:has_children() then
                require("neo-tree.ui.renderer").focus_node(state, node:get_child_ids()[1])
              end
            end
          end,
        },
      },
    },
  },
  {
    "folke/edgy.nvim",
    event = "VeryLazy",
    keys = {
      -- stylua: ignore
      { "<leader>E", function() require("edgy").toggle() end, desc = "Toggle Sidebars" },
      { "<leader>F", function() require("edgy").select() end, desc = "Pick Sidebar" },
    },
    opts = {
      exit_when_last = true,
      bottom = {
        { ft = "qf", title = "QuickFix" },
        {
          ft = "help",
          size = { height = 20 },
          -- don't open help files in edgy that we're editing
          filter = function(buf) return vim.bo[buf].buftype == "help" end,
        },
      },
      left = {
        {
          title = "Files",
          ft = "neo-tree",
          filter = function(buf) return vim.b[buf].neo_tree_source == "filesystem" end,
          pinned = true,
          open = "Neotree position=left filesystem",
          size = { height = 0.5 },
        },
        {
          title = "Git Status",
          ft = "neo-tree",
          filter = function(buf) return vim.b[buf].neo_tree_source == "git_status" end,
          pinned = true,
          open = "Neotree position=right git_status",
        },
        {
          title = "Buffers",
          ft = "neo-tree",
          filter = function(buf) return vim.b[buf].neo_tree_source == "buffers" end,
          pinned = true,
          open = "Neotree position=top buffers",
        },
        "neo-tree",
      },
      right = {
        {
          ft = "aerial",
          title = "Symbol Outline",
          pinned = true,
          open = function() require("aerial").open() end,
        },
      },
      keys = {
        -- increase width
        ["<C-Right>"] = function(win) win:resize("width", 2) end,
        -- decrease width
        ["<C-Left>"] = function(win) win:resize("width", -2) end,
        -- increase height
        ["<C-Up>"] = function(win) win:resize("height", 2) end,
        -- decrease height
        ["<C-Down>"] = function(win) win:resize("height", -2) end,
      },
    },
  },
}
