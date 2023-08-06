ssh-agent -c | lines | first 2 | parse "setenv {name} {value};" | transpose -i -r -d | load-env

#  LS Colors
if (($env | get -s "LSCOLORS") | is-empty) {
  $env.LS_COLORS = 'Exfxcxdxbxegedabagacad'
}
if (($env | get -s "LS_COLORS") | is-empty) {
  $env.LS_COLORS = (^vivid generate snazzy | str trim)
}

# Configuration
$env.PAGER = "bat"
$env.VISUAL = "nvim"
$env.EDITOR = "nvim"
$env.BAT_THEME = 'GitHub'

$env.FZF_DEFAULT_OPTS = '--ansi'
$env.NU_MIN_WORD_LENGTH_FOR_SUGGESTIONS = 3
$env.FZF_DEFAULT_COMMAND = 'fd --type file --color=always'
$env.NU_MAX_NORMALIZED_EDIT_DISTANCE_FOR_SUGGESTIONS = 0.6

$env.ANDROID_HOME = /home/yendor/Android/Sdk
$env.NU_HOME_DIR = ($nu.config-path | path dirname | path expand)

# FNM
if not (which fnm | is-empty) {
  ^fnm env --json | from json | load-env
  $env.PATH = ($env.PATH | prepend [
    $"($env.FNM_MULTISHELL_PATH)/bin"
  ])
}

# Zoxide (https://github.com/ajeetdsouza/zoxide)
let zoxide_path = ($env.NU_HOME_DIR + '/modules/zoxide.nu' | path expand)
if (not ($zoxide_path | path exists)) {
    zoxide init nushell | save -f $zoxide_path
}