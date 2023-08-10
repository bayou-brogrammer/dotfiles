##################
# Internal Config
##################

export PATH=$PATH:/usr/local/bin

function set_win_title(){
    echo -ne "\033]0; $USER@$HOST:${PWD/$HOME/~} \007"
}
precmd_functions+=(set_win_title)

export PAGER="bat"
export EDITOR="nvim"
export VISUAL="nvim"
export BROWSER="google-chrome-stable"
export BAT_THEME="Monokai Extended Light"

echo "Loading ZSH config..."

##################
# Load Internals
##################

source "$ZDOTDIR/config/aliases"
source "$ZDOTDIR/config/options"

#ASDF
case "$OSTYPE" in
  darwin*)
    . /opt/homebrew/bin/asdf
  ;;
  linux*)
   . "$HOME/.asdf/asdf.sh"
  ;;
esac

# fnm
export PATH="/home/yendor/.local/share/fnm:$PATH"
eval "`fnm env`"

# Zoxide
eval "$(zoxide init zsh)"

# Load Mcfly
export MCFLY_FUZZY=true
export MCFLY_RESULTS=20
export MCFLY_INTERFACE_VIEW=BOTTOM
export MCFLY_RESULTS_SORT=LAST_RUN
eval "$(mcfly init zsh)"



