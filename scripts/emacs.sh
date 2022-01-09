#!/usr/bin/env bash 

### Description
# A wrapper for emacsclient; If server is not yet opened, open a server first
# Inspired by https://andy.wordpress.com/2013/01/03/automatic-emacsclient/
# Support both tcp server (-f) and UNIX socket (-s)
#
# emacs.sh -f|s SERVER_NAME [options]
# -f|s is required; -f for TCP server, -s for UNIX socket; SERVER_NAME is the server/socket name. Only gui_server|cli_server is supported right now 
# --sudo: open the file with sudo
###


# get the server name
# although when calling emacs --daemon=<server/socket> with just the file name, emacs will create the server file in the custom directory, when calling emacsclient,
# both -f and -s are relative to its *default* directory. But the default directories are different for -s and -f, so let's always give the absolute path
while getopts ":f:s:-:" option
do
    case "${option}" in
	      f|s) server_name=${OPTARG}
	           server_opt=-${option}
	           server_arg="-${option} ${SERVER_SOCKET_DIR}/${OPTARG}";;
        -) ;; # workaroud, otherwise --sudo will be parsed by -s
    esac
done

# parse arguments
params=()
sudo=""

for ((i = 1; i <= $#; i++ )); do
    if [[ "${!i}" == "--sudo" ]]; then
        sudo="-T /sudo:localhost:"
    elif [[ "${!i}" == "${server_opt}" ]]; then
        # we deal with the server params separately, so skip the option and the argument
	      (( i++ ))
    else 
	      params+=( "${!i}" )
    fi
done

# Checks if there's a frame open
emacsclient -n ${server_arg} -e "(if (> (length (frame-list)) 1) 't)" 2> /dev/null | grep t &> /dev/null

# emacsclient usage: -n and -nw should not be specified together, while -n and -c can (and should always be in our case)
# When -a is specified, default will open CLI; specify -c to open GUI

# if no frame open, open one
if [ "$?" -eq 1 ]; then
    # use emacsclient -a here so that it 1) opens a daemon if no server exists, or 2) opens a frame if server found
    # open a gui server or a cli server based on the first argument
    if [[ "${server_name}" == "gui_server" ]]; then
        # notice when executing alternate editor, filename is passed in automatically so no need to pass again in -a
        # but I haven't figured an elegent way to avoid that, so let it be for now as no functional issue caused
        emacsclient -a "emacs-daemon.sh ${server_arg} $sudo ${params[*]}" -c -n $sudo ${server_arg} "${params[@]}"
    elif [[ "${server_name}" == "cli_server" ]]; then
        emacsclient -a "emacs-daemon.sh ${server_arg} $sudo ${params[*]}" -nw -q $sudo ${server_arg} "${params[@]}"
    fi
else
    if [[ "${server_name}" == "gui_server" ]]; then
        emacsclient -n $sudo ${server_arg} "${params[@]}"
    elif [[ "${server_name}" == "cli_server" ]]; then
	      emacsclient -nw $sudo ${server_arg} "${params[@]}"
    fi
fi

