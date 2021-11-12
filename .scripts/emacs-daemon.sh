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
    # load ssh key to avoid entering passphrase when using tramp
    # but only load if key is found. We do not want to type passphrase at emacs
    # startup bascuse we may not use tramp.
    # will need to type passphrase one time in this case if we use tramp later
    test -r $HOME/.scripts/ssh-agent-setup.sh && . $HOME/.scripts/ssh-agent-setup.sh -d
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
