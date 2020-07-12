#!/usr/bin/env bash

## Wrapper for ssh

test -r $HOME/.scripts/ssh-agent-setup.sh && . $HOME/.scripts/ssh-agent-setup.sh

# if first time open connection, cp emacs server file
if [[ $? -eq  1 ]]; then
    scp ~/.emacs.d/server/gui_server allpan@vm:~/.emacs.d/server 2> /dev/null
fi

ssh "$@"
