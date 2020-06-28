#!/usr/bin/env bash 

## A wrapper for emacsclient; If server is not yet opened, open a server first
# Inspired by https://andy.wordpress.com/2013/01/03/automatic-emacsclient/

# Checks if there's a frame open
emacsclient -n -f ~/.emacs.d/server/server -e "(if (> (length (frame-list)) 1) 't)" 2> /dev/null | grep t &> /dev/null

############### Notices ##################
# When no frame is open, cannot use -n
# -n and -nw should not be specified together; while -n and -c can
# When -a is specified, default will open CLI; specify -c to open GUI
##########################################


# if no frame open, open one
if [ "$?" -eq 1 ]; then

    # test if server exists. If not, open a daemon and try emacsclient again
    emacsclient -a "emacs-daemon.sh $@" -nw -q -f ~/.emacs.d/server/server "$@"

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

