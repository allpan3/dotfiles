#!/usr/bin/env bash

## Wrapper for ssh

# Set up ssh key
test -r $HOME/scripts/ssh-agent-setup.sh && . $HOME/scripts/ssh-agent-setup.sh

## Workaround: remove the remote emacs socket
if [ "${@: -1}" == "vm" ]; then
    \ssh vm "rm /tmp/emacs/remote_emacs.sock" &> /dev/null
fi


ssh $@

