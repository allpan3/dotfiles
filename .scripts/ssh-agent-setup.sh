#!/usr/bin/env bash

## This script is inspired by http://blog.joncairns.com/2013/12/understanding-ssh-agent-and-ssh-add and https://github.com/wwalker/ssh-find-agent

# First, set up ssh key following instruction in http://rabexc.org/posts/using-ssh-agent

if [ -f "$HOME/.ssh/id_rsa" ]; then
    # set up ssh key for every shell opened using the same agent
    . $HOME/.scripts/ssh-find-agent.sh
    # list and automatically choose the fisrt agent
    # if no agent find, create agent
    ssh_find_agent -a ||  eval `ssh-agent` > /dev/null
    # if key not added yet, add key
    ssh-add -l > /dev/null || ssh-add
fi
