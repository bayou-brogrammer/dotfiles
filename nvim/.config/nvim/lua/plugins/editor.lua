return {
  -- spectre.nvim [search and replace in project]
  -- https://github.com/nvim-pack/nvim-spectre
  -- INSTRUCTIONS:
  -- To see the instructions press '?'
  -- To start the search press <ESC>.
  -- It doesn't have ctrl-z so please always commit before using it.
  {
    "nvim-pack/nvim-spectre",
    cmd = "Spectre",
    opts = {
      find_engine = {
        default = {
          find = {
            --pick one of item in find_engine [ag, rg ]
            cmd = "ag",
            options = {},
          },
          replace = {
            -- If you install oxi with cargo you can use it instead.
            cmd = "sed",
          },
        },
      },
      is_insert_mode = true, -- start open panel on is_insert_mode
      mapping = {
        ["toggle_line"] = {
          map = "d",
          cmd = "<cmd>lua require('spectre').toggle_line()<CR>",
          desc = "toggle item.",
        },
        ["enter_file"] = {
          map = "<cr>",
          cmd = "<cmd>lua require('spectre.actions').select_entry()<CR>",
          desc = "open file.",
        },
        ["send_to_qf"] = {
          map = "sqf",
          cmd = "<cmd>lua require('spectre.actions').send_to_qf()<CR>",
          desc = "send all items to quickfix.",
        },
        ["replace_cmd"] = {
          map = "src",
          cmd = "<cmd>lua require('spectre.actions').replace_cmd()<CR>",
          desc = "replace command.",
        },
        ["show_option_menu"] = {
          map = "so",
          cmd = "<cmd>lua require('spectre').show_options()<CR>",
          desc = "show options.",
        },
        ["run_current_replace"] = {
          map = "c",
          cmd = "<cmd>lua require('spectre.actions').run_current_replace()<CR>",
          desc = "confirm item.",
        },
        ["run_replace"] = {
          map = "R",
          cmd = "<cmd>lua require('spectre.actions').run_replace()<CR>",
          desc = "replace all.",
        },
        ["change_view_mode"] = {
          map = "sv",
          cmd = "<cmd>lua require('spectre').change_view()<CR>",
          desc = "results view mode.",
        },
        ["change_replace_sed"] = {
          map = "srs",
          cmd = "<cmd>lua require('spectre').change_engine_replace('sed')<CR>",
          desc = "use sed to replace.",
        },
        ["change_replace_oxi"] = {
          map = "sro",
          cmd = "<cmd>lua require('spectre').change_engine_replace('oxi')<CR>",
          desc = "use oxi to replace.",
        },
        ["toggle_live_update"] = {
          map = "sar",
          cmd = "<cmd>lua require('spectre').toggle_live_update()<CR>",
          desc = "auto refresh changes when nvim writes a file.",
        },
        ["resume_last_search"] = {
          map = "sl",
          cmd = "<cmd>lua require('spectre').resume_last_search()<CR>",
          desc = "repeat last search.",
        },
        ["insert_qwerty"] = {
          map = "i",
          cmd = "<cmd>startinsert<CR>",
          desc = "insert (qwerty).",
        },
        ["insert_colemak"] = {
          map = "o",
          cmd = "<cmd>startinsert<CR>",
          desc = "insert (colemak).",
        },
        ["quit"] = {
          map = "q",
          cmd = "<cmd>lua require('spectre').close()<CR>",
          desc = "quit.",
        },
      },
    },
  },

  -- neotree
  -- https://github.com/nvim-neo-tree/neo-tree.nvim
  {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    cmd = "Neotree",
    init = function() vim.g.neo_tree_remove_legacy_commands = true end,
    opts = function()
      local utils = require "base.utils"
      local get_icon = utils.get_icon
      return {
        auto_clean_after_session_restore = true,
        close_if_last_window = true,
        sources = { "filesystem", "buffers", "git_status" },
        source_selector = {
          winbar = true,
          content_layout = "center",
          sources = {
            {
              source = "filesystem",
              display_name = get_icon("FolderClosed", 1, true) .. "File",
            },
            {
              source = "buffers",
              display_name = get_icon("DefaultFile", 1, true) .. "Bufs",
            },
            {
              source = "git_status",
              display_name = get_icon("Git", 1, true) .. "Git",
            },
            {
              source = "diagnostics",
              display_name = get_icon("Diagnostic", 1, true) .. "Diagnostic",
            },
          },
        },
        default_component_configs = {
          indent = { padding = 0 },
          icon = {
            folder_closed = get_icon "FolderClosed",
            folder_open = get_icon "FolderOpen",
            folder_empty = get_icon "FolderEmpty",
            folder_empty_open = get_icon "FolderEmpty",
            default = get_icon "DefaultFile",
          },
          modified = { symbol = get_icon "FileModified" },
          git_status = {
            symbols = {
              added = get_icon "GitAdd",
              deleted = get_icon "GitDelete",
              modified = get_icon "GitChange",
              renamed = get_icon "GitRenamed",
              untracked = get_icon "GitUntracked",
              ignored = get_icon "GitIgnored",
              unstaged = get_icon "GitUnstaged",
              staged = get_icon "GitStaged",
              conflict = get_icon "GitConflict",
            },
          },
        },
        -- A command is a function that we can assign to a mapping (below)
        commands = {
          system_open = function(state)
            require("base.utils").system_open(state.tree:get_node():get_id())
          end,
          parent_or_close = function(state)
            local node = state.tree:get_node()
            if
                (node.type == "directory" or node:has_children())
                and node:is_expanded()
            then
              state.commands.toggle_node(state)
            else
              require("neo-tree.ui.renderer").focus_node(
                state,
                node:get_parent_id()
              )
            end
          end,
          child_or_open = function(state)
            local node = state.tree:get_node()
            if node.type == "directory" or node:has_children() then
              if not node:is_expanded() then -- if unexpanded, expand
                state.commands.toggle_node(state)
              else                           -- if expanded and has children, seleect the next child
                require("neo-tree.ui.renderer").focus_node(
                  state,
                  node:get_child_ids()[1]
                )
              end
            else -- if not a directory just open it
              state.commands.open(state)
            end
          end,
          copy_selector = function(state)
            local node = state.tree:get_node()
            local filepath = node:get_id()
            local filename = node.name
            local modify = vim.fn.fnamemodify

            local results = {
              e = { val = modify(filename, ":e"), msg = "Extension only" },
              f = { val = filename, msg = "Filename" },
              F = {
                val = modify(filename, ":r"),
                msg = "Filename w/o extension",
              },
              h = {
                val = modify(filepath, ":~"),
                msg = "Path relative to Home",
              },
              p = {
                val = modify(filepath, ":."),
                msg = "Path relative to CWD",
              },
              P = { val = filepath, msg = "Absolute path" },
            }

            local messages = {
              { "\nChoose to copy to clipboard:\n", "Normal" },
            }
            for i, result in pairs(results) do
              if result.val and result.val ~= "" then
                vim.list_extend(messages, {
                  { ("%s."):format(i),           "Identifier" },
                  { (" %s: "):format(result.msg) },
                  { result.val,                  "String" },
                  { "\n" },
                })
              end
            end
            vim.api.nvim_echo(messages, false, {})
            local result = results[vim.fn.getcharstr()]
            if result and result.val and result.val ~= "" then
              vim.notify("Copied: " .. result.val)
              vim.fn.setreg("+", result.val)
            end
          end,
          find_in_dir = function(state)
            local node = state.tree:get_node()
            local path = node:get_id()
            require("telescope.builtin").find_files {
              cwd = node.type == "directory" and path
                  or vim.fn.fnamemodify(path, ":h"),
            }
          end,
        },
        window = {
          width = 30,
          mappings = {
            ["<space>"] = false, -- disable space until we figure out which-key disabling
            ["[b"] = "prev_source",
            ["]b"] = "next_source",
            F = utils.is_available "telescope.nvim" and "find_in_dir" or nil,
            O = "system_open",
            Y = "copy_selector",
            h = "parent_or_close",
            l = "child_or_open",
            o = "open",
            ["e"] = function()
              vim.api.nvim_exec("Neotree focus filesystem left", true)
            end,
            ["b"] = function()
              vim.api.nvim_exec("Neotree focus buffers left", true)
            end,
            ["g"] = function()
              vim.api.nvim_exec("Neotree focus git_status left", true)
            end,
          },
        },
        filesystem = {
          follow_current_file = {
            enabled = true
          },
          hijack_netrw_behavior = "open_current",
          use_libuv_file_watcher = true,
        },
        event_handlers = {
          {
            event = "neo_tree_buffer_enter",
            handler = function(_) vim.opt_local.signcolumn = "auto" end,
          },
        },
      }
    end,
  },
}
