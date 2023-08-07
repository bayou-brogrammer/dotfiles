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

##########
# DEFER
##########
autoload -Uz ~/zsh-defer/zsh-defer

######################
# Source custom
######################
source "$ZDOTDIR/config/load.zsh"

# Autoload functions you might want to use with antidote.
ZFUNCDIR=${ZFUNCDIR:-$ZDOTDIR/functions}
fpath=($ZFUNCDIR $fpath)
autoload -Uz $fpath[1]/*(.:t)

# Source zstyles you might use with antidote.
[[ -e ${ZDOTDIR:-~}/.zstyles ]] && source ${ZDOTDIR:-~}/.zstyles

# Clone antidote if necessary.
# [[ -d ${ZDOTDIR:-~}/.antidote ]] ||
# git clone https://github.com/mattmc3/antidote ${ZDOTDIR:-~}/.antidote

# #######################################################
# # Create an amazing Zsh config using antidote plugins.
# #######################################################

# # Set the name of the static .zsh plugins file antidote will generate.
# zsh_plugins=${ZDOTDIR:-~}/.zsh_plugins.zsh

# # Ensure you have a .zsh_plugins.txt file where you can add plugins.
# [[ -f ${zsh_plugins:r}.txt ]] || touch ${zsh_plugins:r}.txt

# # Lazy-load antidote.
# fpath+=(${ZDOTDIR:-~}/.antidote)
# autoload -Uz $fpath[-1]/antidote

# # Generate static file in a subshell when .zsh_plugins.txt is updated.
# if [[ ! $zsh_plugins -nt ${zsh_plugins:r}.txt ]]; then
#     (antidote bundle <${zsh_plugins:r}.txt >|$zsh_plugins)
# fi

# autoload -Uz compinit && compinit

# # Source your static plugins file.
# source $zsh_plugins

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
### Local Plugins
######################
zi as'null' lucid sbin wait for \
  $ZDOTDIR/plugins/magic_enter.plugin.zsh \
  $ZDOTDIR/plugins/zsh-plugin-fd.plugin.zsh \
  $ZDOTDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh \
  $ZDOTDIR/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
    

# Use fzf
zi as'null' lucid sbin wait for \
  /usr/share/fzf/key-bindings.zsh \
  /usr/share/fzf/completion.zsh

###################### 
### Regular Plugins
######################
zinit for \
    light-mode \
        mattmc3/zman \
    light-mode \
        agkozak/zsh-z \
    light-mode \
        rupa/z \
    light-mode \
        jeffreytse/zsh-vi-mode \
    light-mode \
        icatalina/zsh-navi-plugin \
    light-mode \
        iloginow/zsh-paci \
    light-mode \
        rummik/zsh-tailf \
    light-mode \
     https://github.com/peterhurford/up.zsh 

zi as'null' lucid sbin wait for \
  icatalina/zsh-navi-plugin \

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

# Load powerlevel10k theme
zinit ice depth"1" # git clone depth
zinit light romkatv/powerlevel10k

###################### 
### PROGRAMS
######################

# Binary release in archive, from GitHub-releases page.
# After automatic unpacking it provides program "fzf".
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

###################### 
### Frameworks
######################

# ===== Framework: Oh-My-Zsh ===== #

# lib
zi snippet OMZL::clipboard.zsh
# plugin
zi snippet OMZP::copybuffer
zi snippet OMZP::copyfile
zi snippet OMZP::copypath
zi snippet OMZP::extract

zi snippet OMZP::gh
zi snippet OMZP::fzf
zi snippet OMZP::git
# zi snippet OMZP::gitfast
zi snippet OMZP::zoxide
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
zi snippet OMZP::history-substring-search

# ===== Framework: zsh-utils ===== #
zinit snippet https://github.com/belak/zsh-utils/blob/main/history/history.plugin.zsh
zinit snippet https://github.com/belak/zsh-utils/blob/main/utility/utility.plugin.zsh

###################### 
### Deferred Plugins
######################
# ABBR
zinit ice wait
zi light olets/zsh-abbr

# VIM
zinit ice wait
zi light jeffreytse/zsh-vi-mode

# Syntax highlighting
zinit ice wait
zi light zdharma-continuum/fast-syntax-highlighting

zi as'null' lucid sbin wait'1' for \
  Fakerr/git-recall \
  davidosomething/git-my \
  iwata/git-now \
  paulirish/git-open \
  paulirish/git-recent \
    atload'export _MENU_THEME=legacy' \
  arzzen/git-quick-stats \
    make'install' \
  tj/git-extras \
    make'GITURL_NO_CGITURL=1' \
    sbin'git-url;git-guclone' \
  zdharma-continuum/git-url

###################### 
### Utilities
######################
zi light romkatv/zsh-bench

###################### 
### Local Completions
######################
zi creinstall ${ASDF_DIR}/completions
zi creinstall /usr/share/zsh/site-functions
zinit snippet https://github.com/belak/zsh-utils/blob/main/completion/completion.plugin.zsh

###################### 
### Final Plugins
######################
# These popular core plugins should be loaded at the end
zinit light mattmc3/zfunctions

# Last thing is load the prompt
source $ZDOTDIR/plugins/prompts/load.zsh