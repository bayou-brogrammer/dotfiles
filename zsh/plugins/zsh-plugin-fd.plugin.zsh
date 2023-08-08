#!/bin/sh

###
# shellcheck disable=SC2006,SC2035,SC2086
##

###
# Similar to cd, but using fzf.
#
# E.g: fd [number]
#
# @since Wednesday, 9/11/2019
#
##
fdd () {
    
    if ! [ -x "$(command -v fzf)" ]; then >&2 echo "Please install fzf to use fd." && return 1; fi
    if ! [ -x "$(command -v fd)" ]; then >&2 echo "Requires fd command." && return 1; fi
    
    DEPTH=1
    
    if [ -n "$1" ]; then
        DEPTH="$1"
    fi
    
    DIR=`fd -HLg -d $DEPTH -t directory  | fzf --height=100%` \
    && cd "$DIR" || return 1
    
    return 0
}