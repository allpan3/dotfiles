#!/usr/bin/env bash

### Description
# This script must be sourced
# Options
# -d: do not create ssh-agent or add key if agent/key is not found
# return code
#    0 - key is found
#    1 - key is not found, and added the first time
#    2 - key is not found, but not added due to -d
#   -1 - ssh key is not set up
# This script is inspired by http://blog.joncairns.com/2013/12/understanding-ssh-agent-and-ssh-add and https://github.com/wwalker/ssh-find-agent
# First, set up ssh key following instruction in http://rabexc.org/posts/using-ssh-agent

add_key=1

# reset OPTIND
OPTIND=1
while getopts d option; do
    case $option in
        d) add_key=0 ;;
    esac
done


if [ -f "$HOME/.ssh/id_rsa" ]; then
    # set up ssh key for every shell opened using the same agent
    . $HOME/.scripts/ssh-find-agent.sh
    # list and automatically choose the fisrt agent; if no agent find, create agent
    ssh_find_agent -a
    if [[ $? -ne 0 && $add_key -eq 1 ]]; then
        eval `ssh-agent` > /dev/null
        # then add key
        ssh-add
        return 1
    else
        # if key not added, add key
        ssh-add -l 2> /dev/null
        if [[ $? -ne 0 ]]; then
            if [[ $add_key -eq 1 ]]; then
                ssh-add
                return 1
            else
                return 2
            fi
        fi
    fi
    return 0
fi
return 3
