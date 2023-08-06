local utils = require "kickstart.utils"

local get_icon = utils.helpers.get_icon
local is_available = utils.is_available

local maps = utils.empty_map_table()

local sections = {
	f = { desc = get_icon("Search", 1, true) .. "Find" },
	p = { desc = get_icon("Package", 1, true) .. "Packages" },
	l = { desc = get_icon("ActiveLSP", 1, true) .. "LSP" },
	u = { desc = get_icon("Window", 1, true) .. "UI/UX" },
	b = { desc = get_icon("Tab", 1, true) .. "Buffers" },
	bs = { desc = get_icon("Sort", 1, true) .. "Sort Buffers" },
	d = { desc = get_icon("Debugger", 1, true) .. "Debugger" },
	g = { desc = get_icon("Git", 1, true) .. "Git" },
	S = { desc = get_icon("Session", 1, true) .. "Session" },
	t = { desc = get_icon("Terminal", 1, true) .. "Terminal" },
}

-- Normal --
-- Standard Operations
maps.n["j"] = { "v:count == 0 ? 'gj' : 'j'", expr = true, desc = "Move cursor down" }
maps.n["k"] = { "v:count == 0 ? 'gk' : 'k'", expr = true, desc = "Move cursor up" }
maps.n["<leader>w"] = { "<cmd>w<cr>", desc = "Save" }
maps.n["<leader>q"] = { "<cmd>confirm q<cr>", desc = "Quit" }
maps.n["<leader>n"] = { "<cmd>enew<cr>", desc = "New File" }
maps.n["<C-s>"] = { "<cmd>w!<cr>", desc = "Force write" }
maps.n["<C-q>"] = { "<cmd>qa!<cr>", desc = "Force quit" }
maps.n["|"] = { "<cmd>vsplit<cr>", desc = "Vertical Split" }
maps.n["\\"] = { "<cmd>split<cr>", desc = "Horizontal Split" }

-- Plugin Manager
maps.n["<leader>p"] = sections.p
maps.n["<leader>pi"] = { function() require("lazy").install() end, desc = "Plugins Install" }
maps.n["<leader>ps"] = { function() require("lazy").home() end, desc = "Plugins Status" }
maps.n["<leader>pS"] = { function() require("lazy").sync() end, desc = "Plugins Sync" }
maps.n["<leader>pu"] = { function() require("lazy").check() end, desc = "Plugins Check Updates" }
maps.n["<leader>pU"] = { function() require("lazy").update() end, desc = "Plugins Update" }

utils.set_mappings(maps)
