##################
# Internal Config
##################

function set_win_title(){
    echo -ne "\033]0; $USER@$HOST:${PWD/$HOME/~} \007"
}
precmd_functions+=(set_win_title)

export BAT_THEME="Monokai Extended Light"


#ASDF
zsh-defer $(. "$HOME/.asdf/asdf.sh")

# Zoxide
if (( ! $+commands[zoxide] )); then
    eval "$(zoxide init zsh)"
fi

##################
# Load Internals
##################

source "$ZDOTDIR/config/aliases"
source "$ZDOTDIR/config/mappings"
source "$ZDOTDIR/config/options"

# Load Mcfly
export MCFLY_FUZZY=true
export MCFLY_RESULTS=20
export MCFLY_INTERFACE_VIEW=BOTTOM
export MCFLY_RESULTS_SORT=LAST_RUN
eval "$(mcfly init zsh)"

if (( ! $+commands[fnm] )); then
    # fnm
    export PATH="/home/yendor/.local/share/fnm:$PATH"
    eval "`fnm env`"
fi



