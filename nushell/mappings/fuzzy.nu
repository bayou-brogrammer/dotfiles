$env.config.keybindings = $env.config.keybindings ++ [
  {
    name: fuzzy_module
    modifier: control
    keycode: char_u
    mode: [emacs, vi_normal, vi_insert]
    event: {
        send: executehostcommand
        cmd: '
            commandline --replace "use "
            commandline --insert (
                $env.NU_LIB_DIRS
                | each {|dir|
                    ls ($dir | path join "**" "*.nu")
                    | get name
                    | str replace $dir ""
                    | str trim -c "/"
                }
                | flatten
                | input list --fuzzy
                    $"Please choose a (ansi magenta)module(ansi reset) to (ansi cyan_underline)load(ansi reset):"
            )
        '
    }
  },
  {
    name: fuzzy_dir
    modifier: control
    keycode: char_s
    mode: [emacs, vi_normal, vi_insert]
    event: {
        send: executehostcommand
        cmd: "commandline -a (
            ls **/*
            | where type == dir
            | get name
            | input list --fuzzy
                $'Please choose a (ansi magenta)directory(ansi reset) to (ansi cyan_underline)insert(ansi reset):'
        )"
    }
  }
]