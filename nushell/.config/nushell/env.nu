# Nushell Environment Config File
#
# version = 0.83.1

# Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running external commands (to_string)
# Note: The conversions happen *after* config.nu is loaded
$env.ENV_CONVERSIONS = {
    "PATH": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
    "Path": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
}

# Directories to search for scripts when calling source or use
$env.NU_LIB_DIRS = [
    ($nu.config-path | path dirname | path expand),
    ($nu.default-config-dir | path join 'functions') # add <nushell-config-dir>/scripts
]

# Directories to search for plugin binaries when calling register
$env.NU_PLUGIN_DIRS = [
    ($nu.default-config-dir | path join 'plugins'), # add <nushell-config-dir>/plugins
    ($'($env.HOME)/.cargo/bin'),
]

$env.PATH = (
    $env.PATH
        | split row (char esep)
        | append "/usr/bin"
        | append "/usr/sbin"
        | append "/usr/local/bin"
        | append "/usr/local/sbin"
        | append "/opt/homebrew/bin"
        | append $"($env.HOME)/.cargo/bin"
        | append $"($env.HOME)/.composer/vendor/bin"
        | uniq
)

source-env  ~/.config/nushell/env-yendor.nu