$env.keybindings = $env.config.keybindings ++ [
  {
    name: vscode
    modifier: alt
    keycode: char_z
    mode: [emacs, vi_normal, vi_insert]
    event: [
      {
        send: executehostcommand,
        cmd: "code"
      }
    ]
  }
]

$env.table = ($env.config.table | merge {
  index_mode: "never"
})

$env.completions = ($env.config.completions | merge {
  case_sensitive: true
})

$env.config = ($env.config | merge {
  table: $env.table
  completions: $env.completions
  keybindings: $env.keybindings
})

# Bootup Posh
source ~/.oh-my-posh.nu

# Zoxide
source ~/.zoxide.nu
source scripts/zellij.nu


# All Goodies
source menus/init.nu
source mappings/init.nu
source aliases/init.nu

# # make autocomplete work with zoxide.
# # alias cd = z does not work, as it is missing directory autocompletion
# def-env "cd" [path?:directory] {
#   if ($path | is-empty) {
#     z
#   } else {
#     z ($path | str replace $"($env.PWD)/" "")
#   }
# }