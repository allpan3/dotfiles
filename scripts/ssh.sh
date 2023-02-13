#!/usr/bin/env bash

## Wrapper for ssh

# Set up ssh key
test -r $HOME/scripts/ssh-agent-setup.sh && $HOME/scripts/ssh-find-agent.sh && . $HOME/scripts/ssh-agent-setup.sh

## Workaround: remove the remote emacs socket before logging in
# This is needed because by default remote forwarding cannot overwrite an existing file.
# This may be enabled by a server-side ssh config, but I do not have permission to change.
# But this is only usable when private key is set up for ssh, otherwise we have to enter password twice.
# \ssh ${@: -1} "rm /tmp/emacs-allpan/remote_emacs.sock" &> /dev/null

\ssh $@

