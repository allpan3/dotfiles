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
# update: this issue doesn't exist in one of the "linux-gnu" machines I used. Need
# to find another way to distinguish the problematic system
shopt -s cdable_vars
# correct minor errors in cd directory spelling
shopt -s cdspell
# if a directory name is given as a command name, it is cd'd
shopt -s autocd
# spelling correction on directory names during word completion if the directory name initially supplied does not exist
shopt -s dirspell

########## Aliases ##########
alias ls='ls -F --color=auto'
alias la='ls -A'
alias lt="la -t"
alias ll='la -lh'
alias llt="ll -t"
# list info of directories instead of showing their contents
# usually following wildcards; compare this to ll followed a directory name
alias lld='ll -d'
alias grep='grep --color=auto'
alias zgrep='zgrep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias dgit='git --git-dir=$HOME/.dotfiles.git --work-tree=$HOME'
alias tatt="tmux -CC attach -t"
alias tnew="tmux -CC new -s"
alias tkill="tmux kill-session -t"
alias gitviz="git log --graph --full-history --all --color --pretty=format:\"%x1b[31m%h%x09%x1b[32m%d%x1b[0m%x20%s\""

if [[ "$USER" == "root" ]]; then
  alias rm='rm -i'
  alias cp='cp -i'
  alias mv='mv -i'
fi

########## Emacs #########
export EMACS_SERVER_DIR=/tmp/emacs-allpan # the custom directory for TCP and Socket server
mkdir -p -m 700 $EMACS_SERVER_DIR
alias et="emacs-tramp.sh -n"
alias eg="emacs.sh -s gui_server" # open the file in gui emacs
alias ec="emacs.sh -s cli_server" # open the file in the current terminal window

########## Completion ##########
if type brew &>/dev/null
then
  HOMEBREW_PREFIX="$(brew --prefix)"
  if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]
  then
    source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
  else
    for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*
    do
      [[ -r "${COMPLETION}" ]] && source "${COMPLETION}"
    done
  fi
fi

complete -o nospace -F _cd cd # overwrite cd behavior

########## Keybinding ##########
# readline does not bind over Ctrl-W since it is handled by the terminal driver by default
# run the following command to disable it
# Seems like key binding is causing issue with dumb termimal, temporarily working around by skipping
if [ "$TERM" != "dumb" ]; then
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
fi

########## man page colors ##########
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'

########## Source ##########
export ITERM_ENABLE_SHELL_INTEGRATION_WITH_TMUX=YES
test -e "${HOME}/.iterm2/iterm2_shell_integration.bash" && source "${HOME}/.iterm2/iterm2_shell_integration.bash"

test -e "${HOME}/scripts/git-prompt.sh" && source "${HOME}/scripts/git-prompt.sh"

# .bashrc_local if it exists
if [ -f "$HOME/.bashrc_local" ]; then
    . "$HOME/.bashrc_local"
fi

########## Post Local rc Commands ##########
# unset PROMPT_COMMAND
# Fix prompt for emacs tramp
case "$TERM" in
    "dumb")
        PS1="> "
        ;;
esac
