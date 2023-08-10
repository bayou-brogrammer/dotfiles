local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  -- bootstrap lazy.nvim
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable",
    lazypath })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

-- TODO: set to true on release
-- Whether or not to use stable releases of AstroNvim
local USE_STABLE = false

local spec = {
  -- TODO: remove branch v4 on release
  { "AstroNvim/AstroNvim", branch = "v4", version = USE_STABLE and "*" or nil, import = "astronvim.plugins" },
  -- { "AstroNvim/AstroNvim", version = "3.x", import = "astronvim.plugins" }, -- use this line to only get updates for v3 and avoid the breaking changes if v4 is released
}
if USE_STABLE then
  table.insert(spec, { import = "astronvim.lazy_snapshot" })
end -- pin plugins to known stable versions/commits

require("lazy").setup({
  spec = vim.list_extend(spec, {
    -- AstroCommunity import any community modules here
    { "AstroNvim/astrocommunity", branch = "v4" },

    -- BARS & LINES
    { import = "astrocommunity.bars-and-lines.scope-nvim" },
    { import = "astrocommunity.bars-and-lines.dropbar-nvim" },
    { import = "astrocommunity.bars-and-lines.statuscol-nvim" },
    { import = "astrocommunity.bars-and-lines.smartcolumn-nvim" },

    -- COLOR
    { import = "astrocommunity.color.tint-nvim" },
    { import = "astrocommunity.color.modes-nvim" },
    { import = "astrocommunity.color.headlines-nvim" },

    -- DEBUGGING
    { import = "astrocommunity.debugging.nvim-bqf" },

    -- DIAGNOSTICS
    { import = "astrocommunity.diagnostics.lsp_lines-nvim" },

    -- EDITING SUPPORT
    { import = "astrocommunity.editing-support.vim-move" },
    { import = "astrocommunity.editing-support.comment-box-nvim" },
    { import = "astrocommunity.editing-support.comment-box-nvim" },

    { import = "astrocommunity.git.neogit" },
    { import = "astrocommunity.git.diffview-nvim" },
    { import = "astrocommunity.git.git-blame-nvim" },

    { import = "astrocommunity.motion.harpoon" },
    { import = "astrocommunity.motion.mini-move" },
    { import = "astrocommunity.motion.mini-basics" },
    { import = "astrocommunity.motion.nvim-spider" },
    { import = "astrocommunity.motion.mini-bracketed" },

    { import = "astrocommunity.terminal-integration.vim-tmux-yank" },

    { import = "astrocommunity.utility.telescope-fzy-native-nvim" },
    { import = "astrocommunity.utility.telescope-live-grep-args-nvim" },

    -- TODO: Should probably remove this
    { import = "astrocommunity.workflow.bad-practices-nvim" },

    { import = "plugins" }, -- import/override with your plugins
  }),
  defaults = {
    lazy = false,
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  install = { colorscheme = { "catppuccin", "tokyonight", "habamax", "onedark", "oxocarbon", "duskfox" } },
  checker = { enabled = true }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
