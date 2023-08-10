#!/bin/zsh
#
# .zshrc - Zsh file loaded on interactive shell sessions.
#

##########
# CACHE
##########

# Set ZSH_CACHE_DIR to the path where cache files should be created
# or else we will use the default cache/
if [[ -z "$ZSH_CACHE_DIR" ]]; then
    ZSH_CACHE_DIR="$ZSH/cache"
fi

# Make sure $ZSH_CACHE_DIR is writable, otherwise use a directory in $HOME
if [[ ! -w "$ZSH_CACHE_DIR" ]]; then
    ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
fi

# Create cache and completions dir and add to $fpath
mkdir -p "$ZSH_CACHE_DIR/completions"
(( ${fpath[(Ie)"$ZSH_CACHE_DIR/completions"]} )) || fpath=("$ZSH_CACHE_DIR/completions" $fpath)

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

## Path section
# Set $PATH if ~/.local/bin exist
if [ -d "$HOME/.local/bin" ]; then
    export PATH=$HOME/.local/bin:$PATH
fi

######################
# Source custom
######################
source "$ZDOTDIR/config/load.zsh"

# Autoload functions you might want to use with Zinit.
ZFUNCDIR=${ZFUNCDIR:-$ZDOTDIR/functions}
fpath=($ZFUNCDIR $fpath)
autoload -Uz $fpath[1]/*(.:t)

# Source zstyles you might use with Zinit.
[[ -e ${ZDOTDIR:-~}/.zstyles ]] && source ${ZDOTDIR:-~}/.zstyles

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

###################### 
### PROGRAMS
######################

Binary release in archive, from GitHub-releases page.
After automatic unpacking it provides program "fzf".
zi ice from"gh-r" as"program"
zi light junegunn/fzf

# Scripts built at install (there's single default make target, "install",
# and it constructs scripts by `cat'ing a few files). The make'' ice could also be:
# `make"install PREFIX=$ZPFX"`, if "install" wouldn't be the only default target.
zi ice as"program" pick"$ZPFX/bin/git-*" make"PREFIX=$ZPFX"
zi light tj/git-extras

# One other binary release, it needs renaming from `docker-compose-Linux-x86_64`.
# This is done by ice-mod `mv'{from} -> {to}'. There are multiple packages per
# single version, for OS X, Linux and Windows – so ice-mod `bpick' is used to
# select Linux package – in this case this is actually not needed, Zinit will
# grep operating system name and architecture automatically when there's no `bpick'.
zi ice from"gh-r" as"program" mv"docker* -> docker-compose" bpick"*linux*"
zi load docker/compose

# Scripts built at install (there's single default make target, "install",
# and it constructs scripts by `cat'ing a few files). The make'' ice could also be:
# `make"install PREFIX=$ZPFX"`, if "install" wouldn't be the only default target.
zi ice as"program" pick"$ZPFX/bin/git-*" make"PREFIX=$ZPFX"
zi light tj/git-extras

zi ice from"gh-r" as"program"
zi light jqlang/jq

zi ice as"program" pick"$ZPFX/bin/sk-tmux"
zi light lotabout/skim

##################### 
## Local Plugins
#####################
zinit ice wait lucid
source $ZDOTDIR/plugins/magic_enter.plugin.zsh
source $ZDOTDIR/plugins/zsh-plugin-fd.plugin.zsh

##################### 
## Regular Plugins
#####################

zi as'null' lucid wait'1' for \
  Fakerr/git-recall \
  davidosomething/git-my \
  iwata/git-now \
  paulirish/git-open \
  paulirish/git-recent \
    atload'export _MENU_THEME=legacy' \
  arzzen/git-quick-stats \
    make'install' \
  zdharma-continuum/git-url

# ABBR
zinit ice wait lucid
zi light olets/zsh-abbr

# Syntax highlighting
zi light zdharma-continuum/fast-syntax-highlighting

zinit ice wait lucid
zi light  mattmc3/zman

zinit ice wait lucid
zi light agkozak/zsh-z

zinit ice wait lucid
zi light rupa/z

VIM
zinit ice wait lucid
zi light jeffreytse/zsh-vi-mode

zinit ice wait lucid
zi light icatalina/zsh-navi-plugin

zinit ice wait lucid
zi light iloginow/zsh-paci

zinit ice wait lucid
zi light rummik/zsh-tailf

zinit ice wait lucid
zi light https://github.com/peterhurford/up.zsh 

zi light zsh-users/zsh-history-substring-search

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust \
    zdharma-continuum/zinit-annex-meta-plugins 

zstyle ":plugin:zconvey" greeting "none"
zinit for zdharma2 annexes+con zsh-users+fast console-tools rust-utils

##################### 
## Frameworks
#####################

# ===== Framework: Oh-My-Zsh ===== #

lib
zi snippet OMZL::clipboard.zsh

plugin
zi snippet OMZP::copybuffer
zi snippet OMZP::copyfile
zi snippet OMZP::copypath
zi snippet OMZP::extract

zi snippet OMZP::gh
zi snippet OMZP::fzf
zi snippet OMZP::git
# zi snippet OMZP::gitfast
# zi snippet OMZP::zoxide
zi snippet OMZP::archlinux
zi snippet OMZP::git-extras

zi snippet OMZP::zsh-interactive-cd
zi snippet OMZP::zsh-navigation-tools

zi snippet OMZP::cp
zi snippet OMZP::sudo
zi snippet OMZP::ssh-agent
zi snippet OMZP::fancy-ctrl-z
zi snippet OMZP::command-not-found
zi snippet OMZP::colored-man-pages
# zi snippet OMZP::history-substring-search

# ===== Framework: zsh-utils ===== #
zinit snippet https://github.com/belak/zsh-utils/blob/main/history/history.plugin.zsh
zinit snippet https://github.com/belak/zsh-utils/blob/main/utility/utility.plugin.zsh

##################### 
## Utilities
#####################
zi light romkatv/zsh-bench

##################### 
## Local Completions
#####################
zi for \
    atload"zicompinit; zicdreplay" \
    blockf \
    lucid \
    wait \
  ${ASDF_DIR}/completions

zi for \
    atload"zicompinit; zicdreplay" \
    blockf \
    lucid \
    wait \
  ${HOME}/.local/share/fzf

# ziinit for \
#     atload"zicompinit; zicdreplay" \
#     blockf \
#     lucid \
#     wait \
#     zi snippet https://github.com/belak/zsh-utils/blob/main/completion

zinit ice as'completion'
zinit snippet https://github.com/belak/zsh-utils/blob/main/completion/completion.plugin.zsh

###################### 
### Final Plugins
######################
# These popular core plugins should be loaded at the end
zinit light mattmc3/zfunctions

###################### 
### Mappings
######################
# fzf
zinit load ${HOME}/.local/share/fzf/key-bindings.zsh
source "$ZDOTDIR/config/mappings"

###################### 
### Theme + Prompt
######################
zinit ice depth"1" # git clone depth
zinit light romkatv/powerlevel10k

# Last thing is load the prompt
source $ZDOTDIR/plugins/prompts/load.zsh