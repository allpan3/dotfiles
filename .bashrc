### ~/.bashrc: executed by bash(1) for non-login shells.
### This file is shared between systems. Put any localization features in .bashrc_local

# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
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
# Keybinding
###############################
# readline does not bind over Ctrl-W since it is handled by the terminal driver by default
# run the following command to disable it
# Seems like key binding is causing issue with dumb termimal, temporarily working around by skipping
if [ "$TERM" != "dumb" ]; then
  stty werase undef
  bind '"\C-w":backward-kill-word' # default both bash and neovim
  bind '"\ed":kill-word'           # default in bash
  bind '"\ee":kill-line'           # forward delete line, originally ctrl-k. Map the same in neovim
  bind '"\C-u":backward-kill-line' # default both bash and neovim
fi

###############################
# less and man Page Colors
###############################
# Source: http://unix.stackexchange.com/a/147
# More info: http://unix.stackexchange.com/a/108840
# Man Page: https://linux.die.net/man/5/termcap
export LESS_TERMCAP_mb=$(
  tput bold
  tput setaf 2
) # green
export LESS_TERMCAP_md=$(
  tput bold
  tput setaf 2
)
export LESS_TERMCAP_me=$(tput sgr0)
export LESS_TERMCAP_so=$(
  tput bold
  tput setaf 3
  tput setab 4
) # yellow on blue
export LESS_TERMCAP_se=$(
  tput rmso
  tput sgr0
)
export LESS_TERMCAP_us=$(
  tput smul
  tput bold
  tput setaf 7
) # white
export LESS_TERMCAP_ue=$(
  tput rmul
  tput sgr0
)
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

## Local executable paths
[[ ":$PATH:" =~ ":${HOME}/.local/bin:" ]] || PATH="${HOME}/.local/bin:$PATH" # installed from source
[[ ":$LD_LIBRARY_PATH:" =~ ":${HOME}/.local/lib:" ]] || LD_LIBRARY_PATH="${HOME}/.local/lib${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}"
[[ ":$MANPATH:" =~ ":${HOME}/.local/man:" ]] || MANPATH="${HOME}/.local/share/man${MANPATH:+:${MATHPATH}}"
[[ ":$PATH:" =~ ":${HOME}/.cargo/bin:" ]] || PATH="${HOME}/.cargo/bin:$PATH" # rustup
[[ ":$PATH:" =~ ":${HOME}/.scripts:" ]] || PATH="${HOME}/.scripts:$PATH"     # personal scripts
export PATH LD_LIBRARY_PATH MANPATH

# Set up function for completion for aliases
source ${HOME}/.scripts/complete-alias.sh

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

# iTerm2 shell integration
export ITERM_ENABLE_SHELL_INTEGRATION_WITH_TMUX=YES
test -e "${HOME}/.iterm2/iterm2_shell_integration.bash" && source "${HOME}/.iterm2/iterm2_shell_integration.bash"

# wezterm shell integration
test -e "${HOME}/.config/wezterm/wezterm_shell_integration.sh" && . "${HOME}/.config/wezterm/wezterm_shell_integration.sh"

# git status in prompt
test -e "${HOME}/.scripts/git-prompt.sh" && source "${HOME}/.scripts/git-prompt.sh"

# zoxide
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init bash --cmd cd)"
fi

# starship
# if command -v starship &>/dev/null; then
#   eval "$(starship init bash)"
# fi

# Setting the default source for fzf (respects .ignore)
if type fd &>/dev/null; then
  export FZF_DEFAULT_COMMAND='fd --hidden --type f --strip-cwd-prefix'
fi
# if type rg &> /dev/null; then
#   export FZF_DEFAULT_COMMAND='rg --files --hidden'
# fi

# direnv
if command -v direnv &>/dev/null; then
  eval "$(direnv hook bash)"
fi

# ls - use eza if available
if command -v eza &>/dev/null; then
  alias ls='eza -F --icons=auto --hyperlink'
  alias la='ls -a'
  alias ll='ls -lhg'
  alias lla='la -lhg'
  alias lt="ls -s=oldest" # oldest first
  alias lta="la -s=oldest"
  alias llt="ll -s=newest" # oldest at bottom, easier to see
  alias llta="lla -s=newest"
  alias ltree="eza --tree"
  alias lld='ll -d'
else
  alias ls='ls -F --color=auto'
  alias la='ls -A'
  alias lt="ls -t" # oldest first
  alias lta="la -t"
  alias ll='ls -lh'
  alias lla='la -lh'
  alias llt="ll -tr" # oldest at bottom
  alias llta="lla -tr"
  # List info of directories instead of showing their contents, usually followed by directory name or with wildcards
  # e.g. lld foo*. This is similar to `ll | grep foo`, but useful if wildcard is more than basic
  alias lld='ll -d'
fi

# grep
alias grep='grep --color=auto'
alias zgrep='zgrep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias his="history | grep"

if command -v bat &>/dev/null; then
  alias cat='bat'
fi

if command -v nvim &>/dev/null; then
  alias vi='nvim'
  export EDITOR='nvim'
fi

if command -v zellij --version &>/dev/null; then
  [ -f ${HOME}/.config/zellij/zellij-completion.sh ] && source ${HOME}/.config/zellij/zellij-completion.sh
  alias zj='zellij'
fi

if type fd &>/dev/null; then
  alias fd="fd --hidden"
fi

# tar helper fuctions
targz() { tar -zcvf $1.tar.gz $1; }
untargz() { tar -zxvf $1; }

# tmux iterm2 integration
alias tatt="tmux -CC attach -t"
alias tnew="tmux -CC new -s"
alias tkill="tmux kill-session -t"

# Emacs
export EMACS_SERVER_DIR=/tmp/emacs-allpan # the custom directory for TCP and Socket server
mkdir -p -m 700 $EMACS_SERVER_DIR
alias et="emacs-tramp.sh -n"
alias eg="emacs.sh -s gui_server" # open the file in gui emacs
alias ec="emacs.sh -s cli_server" # open the file in the current terminal window

# git
alias gitviz="git log --graph --full-history --all --color --pretty=format:\"%x1b[31m%h%x09%x1b[32m%d%x1b[0m%x20%s\""

# lazygit
alias lg=lazygit

# accidental action prevention
if [ "$(uname -s)" == "Darwin" ]; then
  trash() {
    if [ "$#" -eq 0 ]; then
      echo "rm: missing operand"
      return 1
    fi
    for file in "$@"; do
      if [ -e "$file" ]; then
        # Move the file to the trash directory with a timestamp to avoid collisions
        mv "$file" "$HOME/.Trash/$(date +%Y%m%d%H%M%S)_$(basename "$file")"
      else
        echo "rm: cannot remove '$file': No such file or directory"
      fi
    done
  }
  alias rm='trash'
elif [[ "$USER" == "root" ]]; then
  alias rm='rm -i'
  alias cp='cp -i'
  alias mv='mv -i'
fi

# Make completion work for aliases
complete -F _complete_alias "${!BASH_ALIASES[@]}"

###############################
# Change directory hook
###############################
_chpwd_hook() {
  shopt -s nullglob

  local f

  # run commands in CHPWD_COMMAND variable on dir change
  if [[ "$PREVPWD" != "$PWD" ]]; then
    local IFS=$';'
    for f in $CHPWD_COMMAND; do
      "$f"
    done
    unset IFS
  fi
  # refresh last working dir record
  export PREVPWD="$PWD"
}

# create a PROPMT_COMMAND equivalent to store chpwd functions
typeset -g CHPWD_COMMAND=""
# add `;` after _chpwd_hook if PROMPT_COMMAND is not empty
PROMPT_COMMAND="_chpwd_hook${PROMPT_COMMAND:+;$PROMPT_COMMAND}"

_zellij_update_tab_name() {
  if [[ -n $ZELLIJ ]]; then
    tab_name=''
    if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
      tab_name+=$(basename "$(git rev-parse --show-toplevel)")/
      # dir wrt git root
      path=$(git rev-parse --show-prefix)
      if [[ -n $path ]]; then
        tab_name+=$(basename $path)
      fi
      tab_name=${tab_name%/}
    else
      tab_name=$PWD
      if [[ $tab_name == $HOME ]]; then
        tab_name="~"
      else
        tab_name=${tab_name##*/}
      fi
    fi
    command nohup zellij action rename-tab $tab_name >/dev/null 2>&1
    # command nohup zellij action rename-session $(PWD)
  fi
}

_zellij_update_tab_name
CHPWD_COMMAND="${CHPWD_COMMAND:+$CHPWD_COMMAND;}_zellij_update_tab_name"
