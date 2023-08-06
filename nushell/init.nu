use ./themes/adventuretime.nu

$env.keybindings = $env.config.keybindings ++ []

$env.table = ($env.config.table | merge {
  index_mode: "never"
})

$env.completions = ($env.config.completions | merge {
  case_sensitive: true
})

$env.config = ($env.config | merge {
  table: $env.table
  color_config: (adventuretime)
  completions: $env.completions
  keybindings: $env.keybindings
})

# Modules
source modules/zoxide.nu
source modules/oh-my-posh.nu

# All Goodies
source sourced/init.nu
source hooks/init.nu
source menus/init.nu
source mappings/init.nu
source modules/init.nu

# LAST
source aliases/init.nu
