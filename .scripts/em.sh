#!/usr/bin/env bash 

## A wrapper for emacsclient; If server is not yet opened, open a server first

# Checks if there's a frame open
emacsclient -n -f ~/.emacs.d/server/server -e "(if (> (length (frame-list)) 1) 't)" 2> /dev/null | grep t &> /dev/null

# if no frame open, open one
if [ "$?" -eq 1 ]; then
    # open a daemon and try emacsclient again
    emacsclient -a '' -nw -q -f ~/.emacs.d/server/server "$@"
else
    params=()
    nw=0
    for p in "$@"; do
        if [ "${p:0:1}" == "-" ]; then
            params+=( "$p" )
            if [ "$p" == "-nw" ] || [ "$p" == "-t" ]; then
                params+=( "$p" )
                nw=1
            fi
        else
            file="$p"
        fi
    done
    if [ "$nw" -eq 0 ]; then
        params+=( "-n" )
    fi
    emacsclient -f ~/.emacs.d/server/server "${params[@]}"  $file
fi

