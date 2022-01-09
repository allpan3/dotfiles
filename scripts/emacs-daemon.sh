#!/usr/bin/env bash

### Description
# Used in emacsclient -a option to start daemon if server not found.
# This file should only be executed once for each server--at the server creation time

# get the server name
while getopts ":T:f:s:" option; do
    case "${option}" in
        f|s)
            server_name=${OPTARG}
    esac
done

if [[ "${server_name}" == *"gui_server" ]]; then
    # Load ssh key to avoid entering passphrase when using tramp
    # But only load if key is found. If not found, don't add because we don't want to type passphrase at emacs startup
    # Will need to type passphrase one time in emacs in the case we start emacs server first, then do ssh
    test -r $HOME/scripts/ssh-agent-setup.sh && . $HOME/scripts/ssh-agent-setup.sh -d
    ret=$?

    emacs --daemon=${server_name}
    # give time for server init to complete since it's in the background
    sleep 0.5
    # open a frame
    emacsclient -c -n $@
elif [[ "${server_name}" == *"cli_server" ]]; then
    emacs --daemon=${server_name}
    emacsclient -nw $@
fi
