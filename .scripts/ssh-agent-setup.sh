#!/usr/bin/env bash

# This script is inspired by http://blog.joncairns.com/2013/12/understanding-ssh-agent-and-ssh-add and https://github.com/wwalker/ssh-find-agent
# First, set up ssh key following instruction in http://rabexc.org/posts/using-ssh-agent

# set up ssh key for every shell opened using the same agent
. $HOME/.scripts/ssh-find-agent.sh
ssh_find_agent -a
if [ "$?" -ne 0 ]; then
    eval `ssh-agent` > /dev/null
fi
ssh-add -l > /dev/null
if [ "$?" -ne 0 ]; then
    ssh-add -l > /dev/null || alias ssh='ssh-add -l || ssh-add && unalias ssh; ssh'
fi

