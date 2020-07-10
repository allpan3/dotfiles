#!/usr/bin/env bash 

### Description
# A wrapper for emacsclient; If server is not yet opened, open a server first
# Inspired by https://andy.wordpress.com/2013/01/03/automatic-emacsclient/
#
# emacs.sh -f SERVER_FILE [options]
# -f is required and must be the first arg
###


# get the server name
while getopts ":f:" option
do
    case "${option}" in
        f) server_name=${OPTARG};;
    esac
done

# Checks if there's a frame open
emacsclient -n -f ${server_name} -e "(if (> (length (frame-list)) 1) 't)" 2> /dev/null | grep t &> /dev/null

############### Notices ##################
# -n and -nw should not be specified together, while -n and -c can (and should
# always be in our case)
# When -a is specified, default will open CLI; specify -c to open GUI
##########################################

# if no frame open, open one
if [ "$?" -eq 1 ]; then

    # test if server exists. If not, open a daemon and try emacsclient again
    # open a gui server or a cli server based on the first argument
    if [ "${server_name}" = "gui_server" ]; then
        emacsclient -a "emacs-daemon.sh $*" -c -n "$@"
    elif [ "${server_name}" = "cli_server" ]; then
        emacsclient -a "emacs-daemon.sh $*" -nw -q "$@"
    fi
else
    if [ "${server_name}" = "gui_server" ]; then
        # all gui files are sent to the opened editor
        emacsclient -n "$@"
    elif [ "${server_name}" = "cli_server" ]; then
        # all cli files are opened with new windows
        emacsclient -nw "$@"
    fi
fi

