return {
  -- change some telescope options and a keymap to browse plugin files
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        config = function()
          require("telescope").load_extension("fzf")
        end,
      },
      {
        "jvgrootveld/telescope-zoxide",
        dependencies = { "nvim-lua/popup.nvim", "nvim-lua/plenary.nvim" },
        config = function()
          require("telescope").load_extension("zoxide")
        end,
      },
    },
    keys = {
      -- add a keymap to browse plugin files
      -- stylua: ignore
      {
        "<leader>fp",
        function() require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root }) end,
        desc = "Find Plugin File",
      },
    },
    -- change some options
    opts = {
      defaults = {
        winblend = 0,
        sorting_strategy = "ascending",
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
      },
      extensions = {
        zoxide = {
          prompt_title = "[ Walking on the shoulders of TJ ]",
        },
      },
    },
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)

      if pcall(require, "zoxide") then
        pcall(telescope.load_extension, "zoxide")
      end

      if pcall(require, "notify") then
        pcall(telescope.load_extension, "notify")
      end

      if pcall(require, "aerial") then
        pcall(telescope.load_extension, "aerial")
      end

      if require("astrocore").is_available("telescope-fzf-native.nvim") then
        pcall(telescope.load_extension, "fzf")
      end
    end,
  },

  -- Flash Telescope config
  {
    "nvim-telescope/telescope.nvim",
    optional = true,
    opts = function(_, opts)
      if not require("astrocore").is_available("flash.nvim") then
        return
      end

      local function flash(prompt_bufnr)
        require("flash").jump({
          pattern = "^",
          label = { after = { 0, 0 } },
          search = {
            mode = "search",
            exclude = {
              function(win)
                return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "TelescopeResults"
              end,
            },
          },
          action = function(match)
            local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
            picker:set_selection(match.pos[1] - 1)
          end,
        })
      end

      opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
        mappings = { n = { s = flash }, i = { ["<c-s>"] = flash } },
      })
    end,
  },
}
