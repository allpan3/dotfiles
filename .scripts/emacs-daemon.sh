#!/usr/bin/env bash

## Used in emacsclient -a option
# Intend to mimic the default -a "" behavior, but not sure if there's anything missed.

# load ssh agent to avoid entering passphrase when using tramp
test -r $HOME/.scripts/ssh-agent-setup.sh && . $HOME/.scripts/ssh-agent-setup.sh

emacs -daemon
emacsclient -a "" -nw -q -f ~/.emacs.d/server/server "$@"

