local my_prefix = function(fs_entry)
  if fs_entry.fs_type == "directory" then
    -- NOTE: it is usually a good idea to use icon followed by space
    return " ", "MiniFilesDirectory"
  end

  return require("mini.files").default_prefix(fs_entry)
end

local minifiles_toggle = function(...)
  if not require("mini.files").close() then
    vim.inspect(...)
    require("mini.files").open(...)
  end
end

local files_set_cwd = function(path)
  -- Works only if cursor is on the valid file system entry
  local cur_entry_path = require("mini.files").get_fs_entry().path
  local cur_directory = vim.fs.dirname(cur_entry_path)
  vim.fn.chdir(cur_directory)
end

local map_split = function(buf_id, lhs, direction)
  local rhs = function()
    -- Make new window and set it as target
    local new_target_window
    vim.api.nvim_win_call(require("mini.files").get_target_window(), function()
      vim.cmd(direction .. " split")
      new_target_window = vim.api.nvim_get_current_win()
    end)

    require("mini.files").set_target_window(new_target_window)
  end

  -- Adding `desc` will result into `show_help` entries
  local desc = "Split " .. direction
  vim.keymap.set("n", lhs, rhs, { buffer = buf_id, desc = desc })
end

return {
  {
    "neo-tree.nvim",
    enabled = false,
  },

  {
    "AstroNvim/astrocore",
    opts = {
      mappings = {
        n = {
          -- Mini files
          ["<leader>e"] = {
            function(...)
              minifiles_toggle(...)
            end,
            desc = "Explorer",
          },
        },
      },
    },
  },

  {
    "echasnovski/mini.files",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "MiniFilesBufferCreate",
        callback = function(args)
          vim.keymap.set("n", "g~", files_set_cwd, { buffer = args.data.buf_id, desc = "Set CWD" })
        end,
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = "MiniFilesBufferCreate",
        callback = function(args)
          vim.inspect(args)
          local buf_id = args.data.buf_id
          -- Tweak keys to your liking
          map_split(buf_id, "gv", "belowright vertical")
          map_split(buf_id, "gs", "belowright horizontal")
        end,
      })
    end,

    config = function(_, opts)
      local utils = require("utils")
      local MiniFiles = require("mini.files")

      local buf_map = function(mode, lhs, rhs, desc)
        -- Use `nowait` to account for non-buffer mappings starting with `lhs`
        utils.map(mode, lhs, rhs, { desc = desc, nowait = true })
      end

      buf_map("n", "<CR>", MiniFiles.open(vim.api.nvim_buf_get_name(0), false), "Close")
    end,

    opts = {
      -- Customization of shown content
      content = {
        -- Predicate for which file system entries to show
        filter = nil,
        -- What prefix to show to the left of file system entry
        prefix = my_prefix,
        -- In which order to show file system entries
        sort = nil,
      },

      -- Module mappings created only inside explorer.
      -- Use `''` (empty string) to not create one.
      mappings = {
        close = "q",
        go_in = "l",
        go_in_plus = "L",
        go_out = "h",
        go_out_plus = "H",
        reset = "<BS>",
        reveal_cwd = "@",
        show_help = "g?",
        synchronize = "=",
        trim_left = "<",
        trim_right = ">",
        -- ["F"] = {
        --   callback = function()
        --     if require("astrocore").is_available("telescope.nvim") then
        --       local oil = require("oil")
        --       local dir = oil.get_current_dir()
        --       require("telescope.builtin").find_files({
        --         cwd = dir and dir or nil,
        --       })
        --     end
        --   end,
        --   desc = "",
        --   nowait = true,
        -- },
      },

      -- General options
      options = {
        -- Whether to delete permanently or move into module-specific trash
        permanent_delete = false,
        -- Whether to use for editing directories
        use_as_default_explorer = true,
      },

      -- Customization of explorer windows
      windows = {
        -- Maximum number of windows to show side by side
        max_number = math.huge,
        -- Whether to show preview of file/directory under cursor
        preview = true,
        -- Width of focused window
        width_focus = 50,
        -- Width of non-focused window
        width_nofocus = 15,
        -- Width of preview window
        width_preview = 25,
      },
    },
  },
}
