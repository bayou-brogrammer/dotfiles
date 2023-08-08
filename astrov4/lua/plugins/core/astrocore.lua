local mappings = {}

return {
  "AstroNvim/astrocore",
  dependencies = { "nvim-lua/plenary.nvim" },
  lazy = false, -- disable lazy loading
  priority = 10000, -- load AstroCore first
  opts = {
    features = {
      cmp = true,
      autopairs = true,
      highlighturl = true,
      notifications = true,
      max_file = { size = 1024 * 100, lines = 10000 },
    },

    -- easily configure auto commands
    autocmds = {
      -- first key is the `augroup` (:h augroup)
      highlighturl = {
        -- list of auto commands to set
        {
          -- events to trigger
          event = { "VimEnter", "FileType", "BufEnter", "WinEnter" },
          -- the rest of the autocmd options (:h nvim_create_autocmd)
          desc = "URL Highlighting",
          callback = function()
            require("astrocore").set_url_match()
          end,
        },
      },
    },

    -- easily configure functions on key press
    on_keys = {
      -- first key is the namespace
      auto_hlsearch = {
        -- list of functions to execute on key press (:h vim.on_key)
        function(char) -- example automatically disables `hlsearch` when not actively searching
          if vim.fn.mode() == "n" then
            local new_hlsearch = vim.tbl_contains({ "<CR>", "n", "N", "*", "#", "?", "/" }, vim.fn.keytrans(char))
            if vim.opt.hlsearch:get() ~= new_hlsearch then
              vim.opt.hlsearch = new_hlsearch
            end
          end
        end,
      },
    },

    -- Enable git integration for detached worktrees
    git_worktrees = {
      { toplevel = vim.env.HOME, gitdir = vim.env.HOME .. "/.dotfiles" },
    },

    -- Configuration table of session options for AstroNvim's session management powered by Resession
    sessions = {
      -- Configure auto saving
      autosave = {
        last = true, -- auto save last session
        cwd = true, -- auto save session for each working directory
      },
      -- Patterns to ignore when saving sessions
      ignore = {
        dirs = {}, -- working directories to ignore sessions in
        filetypes = { "gitcommit", "gitrebase" }, -- filetypes to ignore sessions
        buftypes = {}, -- buffer types to ignore sessions
      },
    },
  },
}
