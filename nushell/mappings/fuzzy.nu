$env.config.keybindings = $env.config.keybindings ++ [
  # <C-r>
  {
    name: fuzzy_history
    modifier: control
    keycode: char_r
    mode: [emacs, vi_normal, vi_insert]
    event: [
      {
        send: ExecuteHostCommand
        cmd: "commandline (
          history
            | each { |it| $it.command }
            | uniq
            | reverse
            | str join (char -i 0)
            | fzf --read0 --layout=reverse --height=40% -q (commandline)
            | decode utf-8
            | str trim
        )"
      }
    ]
  },
]