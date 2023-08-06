return {
	{
		"goolord/alpha-nvim",
		cmd = "Alpha",
		opts = function()
			local dashboard = require "alpha.themes.dashboard"
			dashboard.section.header.val = [[
				_   __ _        _          _                 _    _   _         _            
				| | / /(_)      | |        | |               | |  | \ | |       (_)           
				| |/ /  _   ___ | | __ ___ | |_   __ _  _ __ | |_ |  \| |__   __ _  _ __ ___  
				|    \ | | / __|| |/ // __|| __| / _` || '__|| __|| . ` |\ \ / /| || '_ ` _ \ 
				| |\  \| || (__ |   < \__ \| |_ | (_| || |   | |_ | |\  | \ V / | || | | | | |
				\_| \_/|_| \___||_|\_\|___/ \__| \__,_||_|    \__|\_| \_/  \_/  |_||_| |_| |_|
			]]

			dashboard.section.header.opts.hl = "DashboardHeader"

			local button = require("kickstart.utils.ui").alpha_button
			local get_icon = require("kickstart.utils").get_icon

			dashboard.section.buttons.val = {
				button("LDR n  ", get_icon("FileNew", 2, true) .. "New File  "),
				button("LDR f f", get_icon("Search", 2, true) .. "Find File  "),
				button("LDR f o", get_icon("DefaultFile", 2, true) .. "Recents  "),
				button("LDR f w", get_icon("WordFile", 2, true) .. "Find Word  "),
				button("LDR f '", get_icon("Bookmarks", 2, true) .. "Bookmarks  "),
				button("LDR S l", get_icon("Refresh", 2, true) .. "Last Session  "),
			}

			dashboard.config.layout[1].val = vim.fn.max { 2, vim.fn.floor(vim.fn.winheight(0) * 0.2) }
			dashboard.config.layout[3].val = 5
			dashboard.config.opts.noautocmd = true
			return dashboard
		end,
		config = require "plugins.configs.alpha",
	},

	-- indent guides for Neovim
	{
		"lukas-reineke/indent-blankline.nvim",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			-- char = "▏",
			char = "│",
			filetype_exclude = {
				"help",
				"alpha",
				"dashboard",
				"neo-tree",
				"Trouble",
				"lazy",
				"mason",
				"notify",
				"toggleterm",
				"lazyterm",
			},
			show_trailing_blankline_indent = false,
			show_current_context = false,
		},
	},

	-- Active indent guide and indent text objects. When you're browsing
	-- code, this highlights the current level of indentation, and animates
	-- the highlighting.
	{
		"echasnovski/mini.indentscope",
		version = false, -- wait till new 0.7.0 release to put it back on semver
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			-- symbol = "▏",
			symbol = "│",
			options = { try_as_border = true },
		},
		init = function()
			vim.api.nvim_create_autocmd("FileType", {
				pattern = {
					"help",
					"alpha",
					"dashboard",
					"neo-tree",
					"Trouble",
					"lazy",
					"mason",
					"notify",
					"toggleterm",
					"lazyterm",
				},
				callback = function() vim.b.miniindentscope_disable = true end,
			})
		end,
	},

	-- Better `vim.notify()`
	{
		"rcarriga/nvim-notify",
		keys = {
			{
				"<leader>un",
				function() require("notify").dismiss { silent = true, pending = true } end,
				desc = "Dismiss all Notifications",
			},
		},
		opts = {
			timeout = 3000,
			max_height = function() return math.floor(vim.o.lines * 0.75) end,
			max_width = function() return math.floor(vim.o.columns * 0.75) end,
		},
		init = function()
			-- when noice is not enabled, install notify on VeryLazy
			local Util = require "kickstart.utils"
			if not Util.is_available "noice.nvim" then
				Util.on_very_lazy(function() vim.notify = require "notify" end)
			end
		end,
	},

	-- better vim.ui
	{
		"stevearc/dressing.nvim",
		lazy = true,
		init = function()
			---@diagnostic disable-next-line: duplicate-set-field
			vim.ui.select = function(...)
				require("lazy").load { plugins = { "dressing.nvim" } }
				return vim.ui.select(...)
			end
			---@diagnostic disable-next-line: duplicate-set-field
			vim.ui.input = function(...)
				require("lazy").load { plugins = { "dressing.nvim" } }
				return vim.ui.input(...)
			end
		end,
	},

	-- This is what powers LazyVim's fancy-looking
	-- tabs, which include filetype icons and close buttons.
	{
		"akinsho/bufferline.nvim",
		event = "VeryLazy",
		keys = {
			{ "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle pin" },
			{
				"<leader>bP",
				"<Cmd>BufferLineGroupClose ungrouped<CR>",
				desc = "Delete non-pinned buffers",
			},
		},
		opts = {
			options = {
        -- stylua: ignore
        close_command = function(n) require("mini.bufremove").delete(n, false) end,
        -- stylua: ignore
        right_mouse_command = function(n) require("mini.bufremove").delete(n, false) end,
				diagnostics = "nvim_lsp",
				always_show_bufferline = false,
				diagnostics_indicator = function(_, _, diag)
					local icons = require("kickstart.config").icons.diagnostics
					local ret = (diag.error and icons.Error .. diag.error .. " " or "")
						.. (diag.warning and icons.Warn .. diag.warning or "")
					return vim.trim(ret)
				end,
				offsets = {
					{
						filetype = "neo-tree",
						text = "Neo-tree",
						highlight = "Directory",
						text_align = "left",
					},
				},
			},
		},
	},

	-- statusline
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		opts = function()
			local icons = require("kickstart.config").icons
			local Util = require "kickstart.utils"

			return {
				options = {
					theme = "auto",
					globalstatus = true,
					disabled_filetypes = { statusline = { "dashboard", "alpha" } },
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch" },
					lualine_c = {
						{
							"diagnostics",
							symbols = {
								error = icons.diagnostics.Error,
								warn = icons.diagnostics.Warn,
								info = icons.diagnostics.Info,
								hint = icons.diagnostics.Hint,
							},
						},
						{ "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
						{ "filename", path = 1, symbols = { modified = "  ", readonly = "", unnamed = "" } },
            -- stylua: ignore
            {
              function() return require("nvim-navic").get_location() end,
              cond = function() return package.loaded["nvim-navic"] and require("nvim-navic").has() end,
            },
					},
					lualine_x = {
            -- stylua: ignore
            {
              function() return require("noice").api.status.command.get() end,
              cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
              color = Util.fg("Statement"),
            },
            -- stylua: ignore
            {
              function() return require("noice").api.status.mode.get() end,
              cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
              color = Util.fg("Constant"),
            },
            -- stylua: ignore
            {
              function() return "  " .. require("dap").status() end,
              cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end,
              color = Util.fg("Debug"),
            },
						{
							require("lazy.status").updates,
							cond = require("lazy.status").has_updates,
							color = Util.fg "Special",
						},
						{
							"diff",
							symbols = {
								added = icons.git.added,
								modified = icons.git.modified,
								removed = icons.git.removed,
							},
						},
					},
					lualine_y = {
						{ "progress", separator = " ", padding = { left = 1, right = 0 } },
						{ "location", padding = { left = 0, right = 1 } },
					},
					lualine_z = {
						function() return " " .. os.date "%R" end,
					},
				},
				extensions = { "neo-tree", "lazy" },
			}
		end,
	},

	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
		},
		opts = {
			lsp = {
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
			},
			routes = {
				{
					filter = {
						event = "msg_show",
						any = {
							{ find = "%d+L, %d+B" },
							{ find = "; after #%d+" },
							{ find = "; before #%d+" },
						},
					},
					view = "mini",
				},
			},
			presets = {
				bottom_search = true,
				command_palette = true,
				long_message_to_split = true,
				inc_rename = true,
			},
		},
    -- stylua: ignore
    keys = {
      { "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "Redirect Cmdline" },
      { "<leader>snl", function() require("noice").cmd("last") end, desc = "Noice Last Message" },
      { "<leader>snh", function() require("noice").cmd("history") end, desc = "Noice History" },
      { "<leader>sna", function() require("noice").cmd("all") end, desc = "Noice All" },
      { "<leader>snd", function() require("noice").cmd("dismiss") end, desc = "Dismiss All" },
      { "<c-f>", function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end, silent = true, expr = true, desc = "Scroll forward", mode = {"i", "n", "s"} },
      { "<c-b>", function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, silent = true, expr = true, desc = "Scroll backward", mode = {"i", "n", "s"}},
    },
	},
}
