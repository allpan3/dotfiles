#!/usr/bin/env bash 

### Description
# A wrapper for emacsclient; If server is not yet opened, open a server first
# Inspired by https://andy.wordpress.com/2013/01/03/automatic-emacsclient/
#
# emacs.sh -f|s SERVER_FILE [options]
# -f|s is required. -f arg should just be the server name. -s arg should contain the full path
# --sudo: open the file with sudo
###


# get the server name
while getopts ":f:s:-:" option
do
    case "${option}" in
        f|s) server_name=${OPTARG}
             server_arg="-${option} ${OPTARG}";;
        -) ;; # workaroud, otherwise --sudo will be parsed by -s
    esac
done


# parse arguments
params=()
sudo=""

for p in "$@"
do
    if [[ "$p" == "--sudo" ]]; then
        sudo="-T /sudo:localhost:"
    else
        params+=( "$p" )
    fi
done


# Checks if there's a frame open
emacsclient -n ${server_arg} -e "(if (> (length (frame-list)) 1) 't)" 2> /dev/null | grep t &> /dev/null

# -n and -nw should not be specified together, while -n and -c can (and should
# always be in our case)
# When -a is specified, default will open CLI; specify -c to open GUI

# if no frame open, open one
if [ "$?" -eq 1 ]; then
    # test if server exists. If not, open a daemon and try emacsclient again
    # open a gui server or a cli server based on the first argument
    if [[ "${server_name}" == *"gui_server"* ]]; then
        # notice when executing alternate editor, filename is passed in automatically so no beed to pass in -a
        # but I haven't figured an elegent way to avoid that, so let it filename twice for now
        emacsclient -a "emacs-daemon.sh $sudo ${params[*]}" -c -n $sudo "${params[@]}"
    elif [[ "${server_name}" == *"cli_server"* ]]; then
        emacsclient -a "emacs-daemon.sh $sudo ${params[*]}" -nw -q $sudo "${params[@]}"
    fi
else
    if [[ "${server_name}" == *"gui_server"* ]]; then
        # all gui files are sent to the opened editor
        emacsclient -n $sudo "${params[@]}"
    elif [[ "${server_name}" == *"cli_server"* ]]; then
        # all cli files are opened with new windows
        emacsclient -nw $sudo "${params[@]}"
    fi
fi

