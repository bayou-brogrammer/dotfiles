local wezterm = require("wezterm")
local act = wezterm.action

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

local function activate_pane(window, pane, pane_direction, vim_direction)
	local isViProcess = pane:get_foreground_process_name():find("n?vim") ~= nil
	if isViProcess then
		window:perform_action( -- This should match the keybinds you set in Neovim.
			act.SendKey({ key = vim_direction, mods = "CTRL" }),
			pane
		)
	else
		window:perform_action(act.ActivatePaneDirection(pane_direction), pane)
	end
end

wezterm.on("activate_pane_r", function(window, pane)
	activate_pane(window, pane, "Right", "l")
end)
wezterm.on("activate_pane_l", function(window, pane)
	activate_pane(window, pane, "Left", "h")
end)
wezterm.on("activate_pane_u", function(window, pane)
	activate_pane(window, pane, "Up", "k")
end)
wezterm.on("activate_pane_d", function(window, pane)
	activate_pane(window, pane, "Down", "j")
end)

wezterm.on("create_new_tab", function(window, pane)
	local new_tab, new_pane = window:mux_window():spawn_tab({ cwd = wezterm.home })
	new_tab:set_title("temp")
	new_pane:send_text("wezterm_title ")
end)

--------------------------------------------------------------------------------
--- Config
--------------------------------------------------------------------------------

config.disable_default_key_bindings = true

config.leader = { key = "Space", mods = "CTRL", timeout_milliseconds = 5000 }

config.keys = {
	{ key = "q", mods = "SUPER", action = act.QuitApplication },
	{ key = "v", mods = "SUPER", action = act.PasteFrom("Clipboard") },
	{ key = "r", mods = "LEADER", action = act.ReloadConfiguration },
	{ key = "z", mods = "LEADER", action = act.TogglePaneZoomState },
	{ key = "c", mods = "LEADER", action = act.EmitEvent("create_new_tab") },
	{
		key = "x",
		mods = "LEADER",
		action = act.CloseCurrentPane({ confirm = true }),
	},
	{ key = "1", mods = "LEADER", action = act.ActivateTab(0) },
	{ key = "2", mods = "LEADER", action = act.ActivateTab(1) },
	{ key = "3", mods = "LEADER", action = act.ActivateTab(2) },
	{ key = "4", mods = "LEADER", action = act.ActivateTab(3) },
	{ key = "5", mods = "LEADER", action = act.ActivateTab(4) },
	{ key = "6", mods = "LEADER", action = act.ActivateTab(5) },
	{ key = "7", mods = "LEADER", action = act.ActivateTab(6) },
	{ key = "8", mods = "LEADER", action = act.ActivateTab(7) },
	{ key = "9", mods = "LEADER", action = act.ActivateTab(8) },
	{ key = "0", mods = "LEADER", action = act.ActivateTab(9) },

	{
		key = "|",
		mods = "LEADER|SHIFT",
		action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "-",
		mods = "LEADER",
		action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{ key = "h", mods = "CTRL", action = act.EmitEvent("activate_pane_l") },
	{ key = "j", mods = "CTRL", action = act.EmitEvent("activate_pane_d") },
	{ key = "k", mods = "CTRL", action = act.EmitEvent("activate_pane_u") },
	{ key = "l", mods = "CTRL", action = act.EmitEvent("activate_pane_r") },
}

return config
