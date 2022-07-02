### ~/.bashrc: executed by bash(1) for non-login shells.
### This file is shared between systems. Put any localization features in .bashrc_local

# If not running interactively, don't do anything
case $- in
    *i*) ;;
    *) return;;
esac

########## History ##########
# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000


########## Options ##########
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# an argument to the cd builtin command that is not a directory is assumed
# to be the name of a variable whose value is the directory to change to.
# In darwin and linux, tab completion doesn't suggest variables. But in linux-gnu
# it expands even when I just type `cd <TAB>`, which is annoying so not enabling.
if [[ "$OSTYPE" != "linux-gnu"* ]]; then
    shopt -s cdable_vars
fi
shopt -s cdspell
shopt -s dirspell direxpand


########## Aliases ##########
alias ls='ls -F --color=auto'
alias la='ls -A'
alias ll='la -lh'
alias llt="ll -t"
# list info of directories instead of showing their contents
# usually following wildcards; compare this to ll followed a directory name
alias ld='ll -d'
alias grep='grep --color=auto'
alias zgrep='zgrep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias dgit='git --git-dir=$HOME/.dotfiles.git --work-tree=$HOME'
alias tatt="tmux -CC attach -t"
alias tnew="tmux -CC new -s"
alias tkill="tmux kill-session -t"

########## Variables #########
export EMACS_SERVER_DIR=/tmp/emacs-allpan # the custom directory for TCP and Socket server

########## Keybinding ##########
# readline does not bind over Ctrl-W since it is handled by the terminal driver by default
# run the following command to disable it
stty werase undef
bind "\C-w":backward-delete-char
bind '"\e\C-w":backward-kill-word' # ctrl-alt-n
# need to bind super-ctrl-w to backward-kill-line
bind "\C-h":backward-char
# need to bind ctrl-alt-h to backward-word
# need to bind super-ctrl-h to beginning of the line
bind "\C-l":forward-char
bind "\C-j":next-history
bind "\C-k":previous-history
bind "\C-b":kill-line # forward delete line
bind '"\e[3;4~":backward-kill-line'

########## Source ##########
export ITERM_ENABLE_SHELL_INTEGRATION_WITH_TMUX=YES
test -e "${HOME}/.iterm2/iterm2_shell_integration.bash" && source "${HOME}/.iterm2/iterm2_shell_integration.bash"

# if [ -f "$HOME/.ssh/id_rsa" ]; then
    # . "$HOME/scripts/ssh-agent-setup.sh"
# fi


# .bashrc_local if it exists
if [ -f "$HOME/.bashrc_local" ]; then
    . "$HOME/.bashrc_local"
fi

