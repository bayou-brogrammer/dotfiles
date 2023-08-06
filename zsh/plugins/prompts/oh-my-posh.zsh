export POSH_THEME_HOME="$HOME/.poshthemes"
export POSH_THEME="$POSH_THEME_HOME/jandedobbeleer.omp.json"

alias reloadposh=$(eval "$(oh-my-posh init zsh)")

switchtheme () {
    if ! [ -x "$(command -v fzf)" ]; then >&2 echo "Please install fzf to use fd." && return 1; fi
    if ! [ -x "$(command -v fd)" ]; then >&2 echo "Requires fd command." && return 1; fi
    
    THEME=`fd . '/home/yendor/.poshthemes' | fzf --height=30%` && export POSH_THEME="$THEME" || return 1
    reloadposh
    
    return 0
}

eval "$(oh-my-posh init zsh)"
