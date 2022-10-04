#!/usr/bin/env bash
## Open file on a remote Emacs server (assume remote Emacs server is set up accordingly)
# check https://andy.wordpress.com/2013/01/03/automatic-emacsclient/ with added sudo.

params=()
sudo=0
local=0

for p in "$@"; do
    if [[ "$p" == "--sudo" ]]; then
        sudo=1
    else
        params+=( "${p}" )
    fi
done


if [[ $(id -u) -eq 0 || $sudo -eq 1 ]]; then
    tramp="-T /ssh:$(hostname)|sudo:$(hostname):"
else
    tramp="-T /ssh:$(hostname):"
fi

tramp="-T /ssh:fs:"

# change this code to support both -f and -s
emacsclient -s ${EMACS_SERVER_DIR}/remote_emacs.sock $tramp "${params[@]}"
