$env.config.keybindings = $env.config.keybindings ++ [
  {
      name: completion_menu
      modifier: none
      keycode: tab
      mode: [emacs vi_normal vi_insert]
      event: {
          until: [
              { send: menu name: completion_menu }
              { send: menunext }
          ]
      }
  }
  {
      name: completion_previous
      modifier: shift
      keycode: backtab
      mode: [emacs, vi_normal, vi_insert] # Note: You can add the same keybinding to all modes by using a list
      event: { send: menuprevious }
  }
  {
      name: history_menu
      modifier: control
      keycode: char_h
      mode: emacs
      event: { send: menu name: history_menu }
  }
  {
      name: next_page
      modifier: shift
      keycode: char_l
      mode: emacs
      event: { send: menupagenext }
  }
  {
      name: undo_or_previous_page
      modifier: shift
      keycode: char_h
      mode: emacs
      event: {
          until: [
          { send: menupageprevious }
          { edit: undo }
          ]
      }
  }
  {
      name: yank
      modifier: none
      keycode: char_y
      mode: emacs
      event: {
          until: [
          {edit: pastecutbufferafter}
          ]
      }
  }
  {
      name: commands_menu
      modifier: control
      keycode: char_t
      mode: [emacs, vi_normal, vi_insert]
      event: { send: menu name: commands_menu }
  }
  {
      name: vars_menu
      modifier: none # workaround for alt-v
      keycode: char_√
      mode: [emacs, vi_normal, vi_insert]
      event: { send: menu name: vars_menu }
  }
  {
      name: commands_with_description
      modifier: none # workaround for alt-d
      keycode: char_∂
      mode: [emacs, vi_normal, vi_insert]
      event: { send: menu name: commands_with_description }
  },
  # Custom Keybindings
  {
      name: fzf_zellija
      modifier: none
      keycode: char_ø # workaround for alt-e
      mode: [emacs, vi_normal, vi_insert]
      event: {
          send: executehostcommand,
          cmd: "za"
      }
  }
  {
      name: menu_up
      modifier: none
      keycode: char_∆ # workaround for alt-k
      mode: [emacs, vi_normal, vi_insert]
      event: {
          send: MenuUp,
      }
  }
  {
      name: menu_down
      modifier: none
      keycode: char_º # workaround for alt-j
      mode: [emacs, vi_normal, vi_insert]
      event: {
          send: MenuDown,
      }
  }
  {
      name: history_prev
      modifier: control
      keycode: char_j
      mode: [emacs, vi_normal, vi_insert]
      event: {
          send: PreviousHistory,
      }
  }
  {
      name: history_next
      modifier: control
      keycode: char_k
      mode: [emacs, vi_normal, vi_insert]
      event: {
          send: NextHistory,
      }
  }
  {
      name: clear_screen
      modifier: control
      keycode: char_x
      mode: [emacs, vi_normal, vi_insert]
      event: {
          send: executehostcommand,
          cmd: "clear"
      }
  }
  {
      name: gitui
      modifier: control
      keycode: char_g # workaround for alt-e
      mode: [emacs, vi_normal, vi_insert]
      event: {
          send: executehostcommand,
          cmd: "gitui"
      }
  }
  {
      name: zoxide_menu
      modifier: control
      keycode: char_z
      mode: [emacs, vi_normal, vi_insert]
      event: { send: menu name: zoxide_menu }
  },
]



source fuzzy.nu
