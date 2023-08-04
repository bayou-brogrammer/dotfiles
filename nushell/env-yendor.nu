$env.NU_LIB_DIRS = [
  ($nu.config-path | path dirname | path expand)
  ($nu.config-path | path dirname | path expand | path join "lib")
]


# Configuration
$env.EDITOR = "nvim"
$env.BAT_THEME = 'GitHub'
$env.FZF_DEFAULT_COMMAND = 'fd --type file --color=always'
$env.FZF_DEFAULT_OPTS = '--ansi'
$env.LS_COLORS = (^vivid generate one-light | str trim)
$env.NU_MAX_NORMALIZED_EDIT_DISTANCE_FOR_SUGGESTIONS = 0.6
$env.NU_MIN_WORD_LENGTH_FOR_SUGGESTIONS = 3

ssh-agent -c | lines | first 2 | parse "setenv {name} {value};" | transpose -i -r -d | load-env