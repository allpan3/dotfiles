#!/usr/bin/env bash

## Wrapper for ssh
test -r $HOME/.scripts/ssh-agent-setup.sh && . $HOME/.scripts/ssh-agent-setup.sh

## Workaround: remove the remote emacs socket
# \ssh vm "rm /tmp/emacs/remote_emacs.sock" &> /dev/null

ssh "$@"

