#!/usr/bin/env bash

### Description
# Used in emacsclient -a option
# Intend to mimic the default -a "" behavior, but not sure if there's anything
# missed.

# get the server name
while getopts ":f:" option
do
    case "${option}" in
        f) server_name=${OPTARG};;
    esac
done


emacs --daemon=${server_name}

if [ "${server_name}" = "gui_server" ]; then
    # load ssh agent to avoid entering passphrase when using tramp
    test -r $HOME/.scripts/ssh-agent-setup.sh && . $HOME/.scripts/ssh-agent-setup.sh
    emacsclient -c -n $@
elif [ "${server_name}" = "cli_server" ]; then
    emacsclient -nw $@
fi




