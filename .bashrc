### ~/.bashrc: executed by bash(1) for non-login shells.
### This file is shared between systems. Put any localization features in .bashrc_local

# If not running interactively, don't do anything
case $- in
    *i*) ;;
    *) return;;
esac

###############################
# History 
###############################
# Don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth
# Append to the history file, don't overwrite it
shopt -s histappend
# For setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=500
HISTFILESIZE=2000

###############################
# Options
###############################
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# An argument to the cd builtin command that is not a directory is assumed
# to be the name of a variable (or function, etc.) whose value is the directory to change to.
# Observation so far: Sometimes tab completion suggests variable even
# when I type `cd <TAB>`. Haven't figured out the exact cause of it. May be
# related to bash-completion
# shopt -s cdable_vars

# This option expands variables in the path when typing <TAB>.
# This is still not ideal, but it fixes the issue where the $ sign
# proceeding the variable in a path won't be escaped when <TAB> is typed
shopt -s direxpand

# Correct minor errors in cd directory spelling
shopt -s cdspell
# If a directory name is given as a command name, it is cd'd
shopt -s autocd
# Spelling correction on directory names during word completion if the directory name initially supplied does not exist
shopt -s dirspell

# Append last command to history every time prompt is shown
shopt -s histappend
PROMPT_COMMAND="history -a;$PROMPT_COMMAND"


###############################
# Completion
###############################
complete -o nospace -F _cd cd # overwrite cd behavior

###############################
# Keybinding
###############################
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

###############################
# less and man Page Colors
###############################
# Source: http://unix.stackexchange.com/a/147
# More info: http://unix.stackexchange.com/a/108840
# Man Page: https://linux.die.net/man/5/termcap
export LESS_TERMCAP_mb=$(tput bold; tput setaf 2) # green
export LESS_TERMCAP_md=$(tput bold; tput setaf 2)
export LESS_TERMCAP_me=$(tput sgr0)
export LESS_TERMCAP_so=$(tput bold; tput setaf 3; tput setab 4) # yellow on blue
export LESS_TERMCAP_se=$(tput rmso; tput sgr0)
export LESS_TERMCAP_us=$(tput smul; tput bold; tput setaf 7) # white
export LESS_TERMCAP_ue=$(tput rmul; tput sgr0)
export LESS_TERMCAP_mr=$(tput rev)
export LESS_TERMCAP_mh=$(tput dim)
# export LESS_TERMCAP_ZN=$(tput ssubm)
# export LESS_TERMCAP_ZV=$(tput rsubm)
# export LESS_TERMCAP_ZO=$(tput ssupm)
# export LESS_TERMCAP_ZW=$(tput rsupm)


###############################
# Set up cmdline environment
###############################
## Set up homebrew paths if exists
[ -f /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"

# Source .bashrc_local if it exists
if [ -f "$HOME/.bashrc_local" ]; then
    . "$HOME/.bashrc_local"
fi

## Not sure if this is still needed
# # unset PROMPT_COMMAND
# # Fix prompt for emacs tramp
# # DO this after sourcing local rc since prompt is set in local rc
# case "$TERM" in
#     "dumb")
#         PS1="> "
#         ;;
# esac

# INFO: put source and alias after .bashrc_local because some executables are set up there
# Not sure if this will cause any side effect yet

# git dot
git config --global alias.dot '!git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME'

# iTerm2 shell integration
export ITERM_ENABLE_SHELL_INTEGRATION_WITH_TMUX=YES
test -e "${HOME}/.iterm2/iterm2_shell_integration.bash" && source "${HOME}/.iterm2/iterm2_shell_integration.bash"

# git status in prompt
test -e "${HOME}/scripts/git-prompt.sh" && source "${HOME}/scripts/git-prompt.sh"

# zoxide
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init bash)"
fi

# Setting the default source for fzf (respects .ignore)
if type fd &> /dev/null; then
  export FZF_DEFAULT_COMMAND='fd --hidden --type f --strip-cwd-prefix'
fi
# if type rg &> /dev/null; then
#   export FZF_DEFAULT_COMMAND='rg --files --hidden'
# fi

# Aliases
if command -v exa &> /dev/null; then
    alias ls='exa -F'
    alias la='ls -a'
    alias ll='la -lhg --git'
    alias lt="la -s=oldest"
    alias llt="ll -s=oldest"
else
    alias ls='ls -F --color=auto'
    alias la='ls -A'
    alias lt="la -t"
    alias ll='la -lh'
    alias llt="ll -t"
    # List info of directories instead of showing their contents
    # Usually following wildcards; compare this to ll followed a directory name
    alias lld='ll -d'
fi
alias grep='grep --color=auto'
alias zgrep='zgrep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias tatt="tmux -CC attach -t"
alias tnew="tmux -CC new -s"
alias tkill="tmux kill-session -t"
alias gitviz="git log --graph --full-history --all --color --pretty=format:\"%x1b[31m%h%x09%x1b[32m%d%x1b[0m%x20%s\""
alias his="history | grep"
if command -v bat &> /dev/null; then
  alias cat='bat'
fi
if command -v nvim &> /dev/null; then
  alias vi='nvim'
  alias vim='nvim'
fi
if type fd &> /dev/null; then
  alias fd="fd --hidden"
fi
targz() { tar -zcvf $1.tar.gz $1;}
untargz() { tar -zxvf $1;}

# Emacs
export EMACS_SERVER_DIR=/tmp/emacs-allpan # the custom directory for TCP and Socket server
mkdir -p -m 700 $EMACS_SERVER_DIR
alias et="emacs-tramp.sh -n"
alias eg="emacs.sh -s gui_server" # open the file in gui emacs
alias ec="emacs.sh -s cli_server" # open the file in the current terminal window

# Lazygit
alias lg=lazygit
alias lgd="lazygit --git-dir=$HOME/.dotfiles.git --work-tree=$HOME"

if [[ "$USER" == "root" ]]; then
  alias rm='rm -i'
  alias cp='cp -i'
  alias mv='mv -i'
fi
