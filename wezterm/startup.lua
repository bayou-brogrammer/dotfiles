local wezterm = require 'wezterm'
local act = wezterm.action
local mux = wezterm.mux

wezterm.on('gui-startup', function(cmd)
  -- allow `wezterm start -- something` to affect what we spawn
  -- in our initial window
  local args = {}
  if cmd then args = cmd.args end

  local home = wezterm.home_dir

  local stats_tab, stats_pane, window = mux.spawn_window {
    workspace = 'default',
    cwd = home .. '/.dotfiles'
  }
  -- window:gui_window():maximize()
  stats_pane:send_text('bpytop\n')
  stats_tab:set_title('stats')

  local frontend_tab = window:spawn_tab({ cwd = home .. 'projects' })
  frontend_tab:set_title('frontend')

  window:gui_window():perform_action(act.ActivateTab(0), frontend_tab)
end)

return {}
