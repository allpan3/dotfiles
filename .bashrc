## ~/.bashrc: executed by bash(1) for non-login shells.
### This file is shared between systems. Put any localized features in .bashrc_local

# If not running interactively, don't do anything
# This is typically already handled by /etc/bash.bashrc file
case $- in
*i*) ;;
*) return ;;
esac

# Ghostty shell integration for Bash. This should be at the top of your bashrc!
# Manually sourcing this allows cwd to appear in zellij's pane frame as pane name.
# This somehow doesn't happen if I just let ghostty automatically turn on shell integration
if [ -n "${GHOSTTY_RESOURCES_DIR}" ]; then
  builtin source "${GHOSTTY_RESOURCES_DIR}/shell-integration/bash/ghostty.bash"
fi

# Wezterm shell integration
# test -e "${HOME}/.config/wezterm/wezterm_shell_integration.sh" && . "${HOME}/.config/wezterm/wezterm_shell_integration.sh"

# Set up bash line editor, must be at the top per documentation
test -f ${HOME}/.local/share/blesh/ble.sh && source ${HOME}/.local/share/blesh/ble.sh --attach=none

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
# Don't check mail when opening terminal.
unset MAILCHECK

# History
# Don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth
# Append to the history file, don't overwrite it
shopt -s histappend
# History length in memory
HISTSIZE=500
# History length on disk
HISTFILESIZE=2000
# Append last command to history every time prompt is shown
shopt -s histappend
PROMPT_COMMAND="history -a;$PROMPT_COMMAND"

###############################
# Keybinding
###############################
# Seems like key binding is causing issue with dumb termimal, temporarily working around by skipping
if [ "$TERM" != "dumb" ]; then
  # stty: set terminal type, used to change and print terminal line settings
  # Run stty -a to see all settings
  stty werase undef  # needed to unbind Ctrl-W
  stty discard undef # needed to unbined Ctrl-O
  stty stop undef    # needed to unbined Ctrl-S
  # C-w is already backward delete word by default, but uses a different function
  # backward-kill-word doesn't treat slashes as part of word, more robust.
  bind -m emacs '"\C-w":backward-kill-word'
  bind -m vi-insert '"\C-w":backward-kill-word' # neovim default
  bind -m vi-insert '"\ed":kill-word'           # alt-delete, forward delete word, match emacs mode. Map the same in neoim
  # I try to map special keys to a bash default (emacs mode) at the terminal level whenever possible so that terminal apps are more likely to work right away
  # But forward delete line uses C-k which is reserved for zellij, so bind M-h to forward kill line and then bind M-DEL to it at terminal level 
  # Note remapping this to "\C-k" still won't work in zellij
  bind -m emacs '"\eh":kill-line'         # M-h, forward delete line, originally ctrl-k. Map the same in neovim
  bind -m vi-insert '"\eh":kill-line'     # M-h, forward delete line
  bind -m vi-insert '"\eb":backward-word' # match emacs mode
  bind -m vi-insert '"\ef":forward-word'  # match emacs mode
  bind -m vi-command '"gh":beginning-of-line'
  bind -m vi-command '"gl":end-of-line'
fi

###############################
# Colors
###############################
# Enable true colors in terminal
export COLORTERM=truecolor

# man page and less colors
: "${LESS_TERMCAP_mb:=$'\e[1;32m'}"
: "${LESS_TERMCAP_md:=$'\e[1;32m'}"
: "${LESS_TERMCAP_me:=$'\e[0m'}"
: "${LESS_TERMCAP_se:=$'\e[0m'}"
: "${LESS_TERMCAP_so:=$'\e[1;30;43m'}"
: "${LESS_TERMCAP_ue:=$'\e[0m'}"
: "${LESS_TERMCAP_us:=$'\e[1;4;31m'}"
: "${LESS:=}"
export "${!LESS_TERMCAP@}"
export LESS="R${LESS#-}"
export GROFF_NO_SGR=1

###############################
# PATH Setup
###############################
# Set up homebrew paths if exists
# Manual setup is faster than `eval "$(homebrew/bin/brew shellenv)"`
if [[ -f /opt/homebrew/bin/brew && -z $HOMEBREW_PREFIX ]]; then
  export HOMEBREW_PREFIX="/opt/homebrew"
  export HOMEBREW_CELLAR="$HOMEBREW_PREFIX/Cellar"
  PATH="$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin:$PATH"
  INFOPATH="${HOMEBREW_PREFIX}/share/info:${INFOPATH:-}"
fi

## Local executable paths
[[ ":$PATH:" =~ ":${HOME}/.local/bin:" ]] || PATH="${HOME}/.local/bin:$PATH" # installed from source
[[ ":$LD_LIBRARY_PATH:" =~ ":${HOME}/.local/lib:" ]] || LD_LIBRARY_PATH="${HOME}/.local/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
[[ ":$MANPATH:" =~ ":${HOME}/.local/man:" ]] || MANPATH=":${HOME}/.local/share/man${MANPATH:+$MATHPATH}"
[[ ":$PATH:" =~ ":${HOME}/.cargo/bin:" ]] || PATH="${HOME}/.cargo/bin:$PATH" # rustup
[[ ":$PATH:" =~ ":${HOME}/.scripts:" ]] || PATH="${HOME}/.scripts:$PATH"     # personal scripts
export PATH LD_LIBRARY_PATH MANPATH INFOPATH

# Set up config home for macOS
if [ "$(uname -s)" == "Darwin" ]; then
  export XDG_CONFIG_HOME=${HOME}/.config
fi

###############################
# Load Local rc
###############################
# Put executable setup and alias after this because PATH may be modified there
if [ -f "$HOME/.bashrc_local" ]; then
  . "$HOME/.bashrc_local"
fi

###############################
# Executable Setup
###############################

# zoxide
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init bash --cmd cd)"
fi

# starship
if command -v starship &>/dev/null; then
  eval "$(starship init bash)"
  function set_win_title(){
    echo -ne "\033]0; "$PWD" \007"
  }
  starship_precmd_user_func="set_win_title"
fi

# atuin
# command -v atuin &>/dev/null && eval "$(atuin init bash)"

# fzf, must be loaded after bash_completion
# if ble.sh enabled, let .blerc handle
if command -v fzf &>/dev/null && [[ -z ${BLE_VERSION-} ]]; then
  # fzf shell intergration
  eval "$(fzf --bash)"
  source ~/.fzf.bash
  fzf_bind_cd_widget
  fzf_bind_cd_repo_widget
fi

# dircolors
if command -v dircolors &>/dev/null; then
  eval "$(dircolors -b ${HOME}/.config/dircolors)"
fi

# direnv
if command -v direnv &>/dev/null; then
  eval "$(direnv hook bash)"
fi

## thefuck
## thefuck startup is slow
## if command -v fuck &>/dev/null; then
##   eval $(thefuck --alias)
## fi

###############################
# Aliases & Utility Functions
###############################
# Set up function for completion for aliases
# Place this after all command and default complete are sourced
# Use auto unmask to record the default completion
export COMPAL_AUTO_UNMASK=1
source ${HOME}/.scripts/complete-alias.sh

# emulate tree if it's not installed
if ! type tree >/dev/null; then
  alias tree="find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'"
fi

# ls - use eza if available
if command -v eza &>/dev/null; then
  alias ls='eza -F --icons=auto --hyperlink'
  alias la='ls -a'
  alias ld='ls -d'
  alias lda='la -d'
  alias ll='ls -lhg'
  alias lla='la -lhg'
  alias lt="ls -s=oldest" # oldest first
  alias lta="la -s=oldest"
  alias llt="ll -s=newest" # oldest at bottom, easier to see
  alias llta="lla -s=newest"
  alias lld='ll -d'
  alias tree="eza --tree"
else
  if command ls --color -d . &>/dev/null; then
    alias ls='ls -F --color=auto'
    # BSD `ls` doesn't need an argument (`-G`) when `$CLICOLOR` is set.
  fi
  alias la='ls -A'
  alias ld='ls -d'
  alias lda='la -d'
  alias lt="ls -t" # oldest first
  alias lta="la -t"
  alias l1='ls -1'
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

alias ..='cd ..'
alias ...='cd ../..'     # Go up two directories
alias ....='cd ../../..' # Go up three directories

alias md='mkdir -p'
alias rd='rmdir'

if type rg &>/dev/null; then
  alias rg='rg --smart-case --hidden'
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

function bak() {
  local filename="${1?}" filetime
  filetime=$(date +%Y%m%d_%H%M%S)
  cp -a "${filename}" "${filename}_${filetime}"
}

# tar helper fuctions
targz() { tar -zcvf $1.tar.gz $1; }
untargz() { tar -zxvf $1; }

alias py='python'

# git
alias gd='git diff'
alias gds='git diff --staged'
alias gdt='git difftool'
function gdv() {
  git diff --ignore-all-space "$@" | vi -R -
}
alias gf='git fetch --all --prune --tags'
alias gl='git log --graph --date=short --pretty=format:'\''%C(auto)%h %Cgreen%an%Creset %Cblue%cd%Creset %C(auto)%d %s'\'''
alias gls='gg --stat'
alias ggup='git log --branches --not --remotes --no-walk --decorate --oneline' # FROM https://stackoverflow.com/questions/39220870/in-git-list-names-of-branches-with-unpushed-commits
alias gll="git log --graph --full-history --all --color --pretty=format:\"%x1b[31m%h%x09%x1b[32m%d%x1b[0m%x20%s\""
alias gnew='git log HEAD@{1}..HEAD@{0}' # Show commits since last pull, see http://blogs.atlassian.com/2014/10/advanced-git-aliases/
alias gmv='git mv'
alias grm='git rm'
alias grms='git rm --cached'       # Removes the file only from the Git repository, but not from the filesystem.
alias gpatch='git format-patch -1' # gpatch <commit>
alias gph='git push'
alias gphf='git push --force-with-lease'
alias gpl='git pull --prune'
alias gplr='git pull --prune --rebase'
alias grb='git rebase'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'
alias gsu='git submodule update --init --recursive'

function git-ignore() {
  # about 'Places the latest .gitignore file for a given project type in the current directory, or concatenates onto an existing .gitignore'
  # group 'git'
  # param '1: the language/type of the project, used for determining the contents of the .gitignore file'
  # example '$ gittowork java'

  result=$(curl -L "https://www.gitignore.io/api/$1" 2>/dev/null)

  if [[ "${result}" =~ ERROR ]]; then
    echo "Query '$1' has no match. See a list of possible queries with 'gittowork list'"
  elif [[ $1 == list ]]; then
    echo "${result}"
  else
    if [[ -f .gitignore ]]; then
      result=$(grep -v "# Created by http://www.gitignore.io" <<<"${result}")
      echo ".gitignore already exists, appending..."
    fi
    echo "${result}" >>.gitignore
  fi
}

# lazygit
alias lg=lazygit

# Accidental action prevention
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
# This conflicts with blesh, which automatically handles alias completion
if [[ -z ${BLE_VERSION-} ]]; then
  complete -F _complete_alias "${!BASH_ALIASES[@]}"
fi

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
    # use --is-inside-work-tree instead of --git-dir so that non-worktree directories (like .git/) won't evalute to true
    # this is needed beacuse the proceeding commands only work inside worktree
    if [[ "$(git rev-parse --is-inside-work-tree 2>/dev/null)" == "true" ]]; then
      root=$(git rev-parse --show-toplevel)
      # since my home directory is a repo, also need to handle the shortening here
      if [[ $root == $HOME ]]; then
        tab_name+="~/"
      else
        tab_name+=$(basename "$(git rev-parse --show-toplevel)")/
      fi
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
      # don't strip off / if the pwd is /
      elif [[ $tab_name != "/" ]]; then
        tab_name=${tab_name##*/}
      fi
    fi
    command nohup zellij action rename-tab $tab_name >/dev/null 2>&1
  fi
}

_zellij_update_tab_name
CHPWD_COMMAND=${CHPWD_COMMAND:+$CHPWD_COMMAND;}_zellij_update_tab_name

# This needs to be placed at the end according to the documentation
if [[ ${BLE_VERSION-} ]]; then
  set -o vi
  # ble/debug/profiler/start
  ble-attach
  # ble/debug/profiler/stop
fi
