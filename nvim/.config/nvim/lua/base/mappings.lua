-- nvim keybindings (qwerty).
--
-- DESCRIPTION:
-- All mappings are defined here, and on "../utils/lsp.lua".
-- Note that "../utils/lsp.lua" will always prevail over "mappings.lua".

--
--   KEYBINDINGS REFERENCE
--   -------------------------------------------------------------------
--   |        Mode  | Norm | Ins | Cmd | Vis | Sel | Opr | Term | Lang |
--   Command        +------+-----+-----+-----+-----+-----+------+------+
--   [nore]map      | yes  |  -  |  -  | yes | yes | yes |  -   |  -   |
--   n[nore]map     | yes  |  -  |  -  |  -  |  -  |  -  |  -   |  -   |
--   [nore]map!     |  -   | yes | yes |  -  |  -  |  -  |  -   |  -   |
--   i[nore]map     |  -   | yes |  -  |  -  |  -  |  -  |  -   |  -   |
--   c[nore]map     |  -   |  -  | yes |  -  |  -  |  -  |  -   |  -   |
--   v[nore]map     |  -   |  -  |  -  | yes | yes |  -  |  -   |  -   |
--   x[nore]map     |  -   |  -  |  -  | yes |  -  |  -  |  -   |  -   |
--   s[nore]map     |  -   |  -  |  -  |  -  | yes |  -  |  -   |  -   |
--   o[nore]map     |  -   |  -  |  -  |  -  |  -  | yes |  -   |  -   |
--   t[nore]map     |  -   |  -  |  -  |  -  |  -  |  -  | yes  |  -   |
--   l[nore]map     |  -   | yes | yes |  -  |  -  |  -  |  -   | yes  |
--   -------------------------------------------------------------------

local utils = require "base.utils"
local ui = require "base.utils.ui"
local actions = require "base.utils.actions"

local get_icon = utils.get_icon
local is_available = utils.is_available
local maps = require("base.utils").empty_map_table()

-- -------------------------------------------------------------------------
--
-- ## Base bindings ########################################################
--
-- -------------------------------------------------------------------------

-- sections displayed on which-key.nvim ---------------------------------------
local sections = {
  g = { desc = get_icon("Git", 1, true) .. "Git" },
  u = { desc = get_icon("Window", 1, true) .. "UI" },
  dc = { desc = get_icon("Docs", 1, true) .. "Docs" },
  f = { desc = get_icon("Search", 1, true) .. "Find" },
  b = { desc = get_icon("Tab", 1, true) .. "Buffers" },
  l = { desc = get_icon("ActiveLSP", 1, true) .. "LSP" },
  S = { desc = get_icon("Session", 1, true) .. "Session" },
  p = { desc = get_icon("Package", 1, true) .. "Packages" },
  d = { desc = get_icon("Debugger", 1, true) .. "Debugger" },
  t = { desc = get_icon("Terminal", 1, true) .. "Terminal" },
  bs = { desc = get_icon("Sort", 1, true) .. "Sort Buffers" },
}

-----------------------
-- Standard Operations
-----------------------

maps.n["j"] = { "v:count == 0 ? 'gj' : 'j'", expr = true, desc = "Move cursor down" }
maps.n["k"] = { "v:count == 0 ? 'gk' : 'k'", expr = true, desc = "Move cursor up" }
maps.n["<leader>w"] = { "<cmd>w<cr>", desc = "Save" }
maps.n["<leader>q"] = { "<cmd>confirm q<cr>", desc = "Quit" }
maps.n["<leader>n"] = { "<cmd>enew<cr>", desc = "New File" }
maps.n["<C-s>"] = { "<cmd>w!<cr>", desc = "Force write" }
maps.n["<C-q>"] = { "<cmd>qa!<cr>", desc = "Force quit" }
maps.n["|"] = { "<cmd>vsplit<cr>", desc = "Vertical Split" }
maps.n["\\"] = { "<cmd>split<cr>", desc = "Horizontal Split" }
-- TODO: Remove when dropping support for <Neovim v0.10
if not vim.ui.open then maps.n["gx"] = { utils.system_open, desc = "Open the file under cursor with system app" } end

-----------------------
-- search highlighing
-----------------------

-- use ESC to clear hlsearch, while preserving its original functionality.
--
-- TIP: If you prefer,  use <leader>ENTER instead of <ESC>
--      to avoid triggering it by accident.
maps.n["<ESC>"] = {
  function()
    if vim.fn.hlexists "Search" then
      vim.cmd "nohlsearch"
    else
      vim.api.nvim_feedkeys(
        vim.api.nvim_replace_termcodes("<ESC>", true, true, true),
        "n",
        true
      )
    end
  end,
}

-- Improved tabulation ------------------------------------------------------
maps.x["<S-Tab>"] = { "<gv", desc = "unindent line" }
maps.x["<Tab>"] = { ">gv", desc = "indent line" }
maps.x["<"] = { "<gv", desc = "unindent line" }
maps.x[">"] = { ">gv", desc = "indent line" }

-----------------------
-- packages
-----------------------
-- lazy
maps.n["<leader>p"] = sections.p
maps.n["<leader>pi"] = { function() require("lazy").install() end, desc = "Plugins Install" }
maps.n["<leader>ps"] = { function() require("lazy").home() end, desc = "Plugins Status" }
maps.n["<leader>pS"] = { function() require("lazy").sync() end, desc = "Plugins Sync" }
maps.n["<leader>pu"] = { function() require("lazy").check() end, desc = "Plugins Check Updates" }
maps.n["<leader>pU"] = { function() require("lazy").update() end, desc = "Plugins Update" }

-- mason
if is_available "mason.nvim" then
  maps.n["<leader>pm"] = { "<cmd>Mason<cr>", desc = "Mason Installer" }
  maps.n["<leader>pM"] = { "<cmd>MasonUpdateAll<cr>", desc = "Mason Update" }
end

-- nvim updater
maps.n["<leader>pA"] = { "<cmd>NvimUpdate<cr>", desc = "Nvim Update" }
maps.n["<leader>pv"] = { "<cmd>NvimVersion<cr>", desc = "Nvim Version" }
maps.n["<leader>pl"] = { "<cmd>NvimChangelog<cr>", desc = "Nvim Changelog" }
maps.n["<leader>pa"] = { "<cmd>NvimUpdatePackages<cr>", desc = "Update Plugins and Mason" }

-----------------------
-- buffers/tabs [buffers ]
-----------------------
maps.n["<leader>b"] = sections.b

-- Manage Buffers
maps.n["<leader>c"] = { function() require("astronvim.utils.buffer").close() end, desc = "Close buffer" }
maps.n["<leader>C"] = { function() require("astronvim.utils.buffer").close(0, true) end, desc = "Force close buffer" }

maps.n["]b"] = {
  desc = "Next buffer",
  function() require("base.utils.buffer").nav(vim.v.count > 0 and vim.v.count or 1) end,
}
maps.n["[b"] = {
  desc = "Previous buffer",
  function() require("base.utils.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1)) end,
}
maps.n[">b"] = {
  desc = "Move buffer tab right",
  function() require("base.utils.buffer").move(vim.v.count > 0 and vim.v.count or 1) end,
}
maps.n["<b"] = {
  desc = "Move buffer tab left",
  function() require("base.utils.buffer").move(-(vim.v.count > 0 and vim.v.count or 1)) end,
}

maps.n["<leader>bc"] =
{ function() require("base.utils.buffer").close_all(true) end, desc = "Close all buffers except current" }
maps.n["<leader>bC"] = { function() require("base.utils.buffer").close_all() end, desc = "Close all buffers" }
-- maps.n["<leader>bb"] = {
--   function()
--     require("base.utils.status.heirline").buffer_picker(function(bufnr) vim.api.nvim_win_set_buf(0, bufnr) end)
--   end,
--   desc = "Select buffer from tabline",
-- }
-- maps.n["<leader>bd"] = {
--   function()
--     require("base.utils.status.heirline").buffer_picker(
--       function(bufnr) require("base.utils.buffer").close(bufnr) end
--     )
--   end,
--   desc = "Close buffer from tabline",
-- }

maps.n["<leader>bs"] = sections.bs

-- Navigate tabs
maps.n["]t"] = { function() vim.cmd.tabnext() end, desc = "Next tab" }
maps.n["[t"] = { function() vim.cmd.tabprevious() end, desc = "Previous tab" }

-- -------------------------------------------------------------------------
--
-- ## Plugin bindings
--
-- -------------------------------------------------------------------------

-- alpha-nvim --------------------------------------------------------------
if is_available "alpha-nvim" then
  maps.n["<leader>h"] = {
    function()
      local wins = vim.api.nvim_tabpage_list_wins(0)
      if
          #wins > 1
          and vim.api.nvim_get_option_value("filetype", { win = wins[1] })
          == "neo-tree"
      then
        vim.fn.win_gotoid(wins[2]) -- go to non-neo-tree window to toggle alpha
      end
      require("alpha").start(false, require("alpha").default_config)
    end,
    desc = "Home screen",
  }
end

-- [git] -----------------------------------------------------------
-- gitsigns.nvim
maps.n["<leader>g"] = sections.g
if is_available "gitsigns.nvim" then
  maps.n["<leader>g"] = sections.g
  maps.n["]g"] = { function() require("gitsigns").next_hunk() end, desc = "Next Git hunk" }
  maps.n["[g"] = { function() require("gitsigns").prev_hunk() end, desc = "Previous Git hunk" }
  maps.n["<leader>gl"] = { function() require("gitsigns").blame_line() end, desc = "View Git blame" }
  maps.n["<leader>gL"] = { function() require("gitsigns").blame_line { full = true } end, desc = "View full Git blame" }
  maps.n["<leader>gp"] = { function() require("gitsigns").preview_hunk() end, desc = "Preview Git hunk" }
  maps.n["<leader>gh"] = { function() require("gitsigns").reset_hunk() end, desc = "Reset Git hunk" }
  maps.n["<leader>gr"] = { function() require("gitsigns").reset_buffer() end, desc = "Reset Git buffer" }
  maps.n["<leader>gs"] = { function() require("gitsigns").stage_hunk() end, desc = "Stage Git hunk" }
  maps.n["<leader>gS"] = { function() require("gitsigns").stage_buffer() end, desc = "Stage Git buffer" }
  maps.n["<leader>gu"] = { function() require("gitsigns").undo_stage_hunk() end, desc = "Unstage Git hunk" }
  maps.n["<leader>gd"] = { function() require("gitsigns").diffthis() end, desc = "View Git diff" }
end

-- git fugitive
if is_available "vim-fugitive" then
  maps.n["<leader>gP"] = {
    function() vim.cmd ":GBrowse" end,
    desc = "Open in github ",
  }
end

-- git client
if vim.fn.executable "lazygit" == 1 then -- if lazygit exists, show it
  maps.n["<leader>gg"] = {
    function()
      local git_dir = vim.fn.finddir(".git", vim.fn.getcwd() .. ";")
      if git_dir ~= "" then
        actions.toggle_term_cmd "lazygit"
      else
        actions.notify("Not a git repository", 4)
      end
    end,
    desc = "ToggleTerm lazygit",
  }
end

-- file browsers ------------------------------------
-- ranger
if is_available "rnvimr" then
  maps.n["<leader>r"] = { "<cmd>RnvimrToggle<cr>", desc = "Ranger" }
end

-- neotree
if is_available "neo-tree.nvim" then
  maps.n["<leader>e"] = { "<cmd>Neotree toggle<cr>", desc = "Toggle neotree" }
  maps.n["<leader>o"] = {
    function()
      if vim.bo.filetype == "neo-tree" then
        vim.cmd.wincmd "p"
      else
        vim.cmd.Neotree "focus"
      end
    end,
    desc = "Toggle Neotree Focus",
  }
end

-- Smart Splits
if is_available "smart-splits.nvim" then
  maps.n["<C-h>"] = { function() require("smart-splits").move_cursor_left() end, desc = "Move to left split" }
  maps.n["<C-j>"] = { function() require("smart-splits").move_cursor_down() end, desc = "Move to below split" }
  maps.n["<C-k>"] = { function() require("smart-splits").move_cursor_up() end, desc = "Move to above split" }
  maps.n["<C-l>"] = { function() require("smart-splits").move_cursor_right() end, desc = "Move to right split" }
  maps.n["<C-Up>"] = { function() require("smart-splits").resize_up() end, desc = "Resize split up" }
  maps.n["<C-Down>"] = { function() require("smart-splits").resize_down() end, desc = "Resize split down" }
  maps.n["<C-Left>"] = { function() require("smart-splits").resize_left() end, desc = "Resize split left" }
  maps.n["<C-Right>"] = { function() require("smart-splits").resize_right() end, desc = "Resize split right" }
else
  maps.n["<C-h>"] = { "<C-w>h", desc = "Move to left split" }
  maps.n["<C-j>"] = { "<C-w>j", desc = "Move to below split" }
  maps.n["<C-k>"] = { "<C-w>k", desc = "Move to above split" }
  maps.n["<C-l>"] = { "<C-w>l", desc = "Move to right split" }
  maps.n["<C-Up>"] = { "<cmd>resize -2<CR>", desc = "Resize split up" }
  maps.n["<C-Down>"] = { "<cmd>resize +2<CR>", desc = "Resize split down" }
  maps.n["<C-Left>"] = { "<cmd>vertical resize -2<CR>", desc = "Resize split left" }
  maps.n["<C-Right>"] = { "<cmd>vertical resize +2<CR>", desc = "Resize split right" }
end

-- SymbolsOutline
if is_available "aerial.nvim" then
  maps.n["<leader>l"] = sections.l
  maps.n["<leader>lS"] = { function() require("aerial").toggle() end, desc = "Symbols outline" }
end
