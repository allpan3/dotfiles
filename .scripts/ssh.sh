#!/usr/bin/env bash

## Wrapper for ssh

test -r $HOME/.scripts/ssh-agent-setup.sh && . $HOME/.scripts/ssh-agent-setup.sh
ssh "$@"
