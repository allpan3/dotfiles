## ~/.bashrc: executed by bash(1) for non-login shells.
### This file is shared between systems. Put any localized features in .bashrc_local

# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

# Ghostty shell integration for Bash. This should be at the top of your bashrc!
# Manually sourcing to fix ble.sh issue (https://github.com/akinomyoga/ble.sh/issues/543)
if [ -n "${GHOSTTY_RESOURCES_DIR}" ]; then
  builtin source "${GHOSTTY_RESOURCES_DIR}/shell-integration/bash/ghostty.bash"
fi

# Set up bash line editor, must be at the top per documentation
test -f ${HOME}/.local/share/blesh/ble.sh && source ${HOME}/.local/share/blesh/ble.sh --attach=none

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
# Seems like key binding is causing issue with dumb termimal, temporarily working around by skipping
if [ "$TERM" != "dumb" ]; then
  # stty: set terminal type, used to change and print terminal line settings
  # Run stty -a to see all settings
  stty werase undef  # needed to unbind Ctrl-W
  stty discard undef # needed to unbined Ctrl-O
  stty stop undef    # needed to unbined Ctrl-S
  # C-w is already backward delete word by default, but uses are different function
  # backward-kill-word doesn't treat slashes as part of word, more robust.
  bind -m emacs '"\C-w":backward-kill-word'
  bind -m vi-insert '"\C-w":backward-kill-word' # neovim default
  bind -m vi-insert '"\ed":kill-word'           # alt-delete, forward delete word, match emacs mode. Map the same in neoim
  # I try to map special keys to a bash default (emacs mode) at the terminal level whenever possible so that terminal apps are more likely to work right away
  # But forward delete line uses C-k which is reserved for zellij, so have to bind M-DEL explicitly
  # Note remapping this to "\C-k" still won't work in zellij
  bind -m emacs '"\e[3;9~":kill-line'     # super-delete, forward delete line, originally ctrl-k. Map the same in neovim
  bind -m vi-insert '"\e[3;9~":kill-line' # super-delete, forward delete line
  bind -m vi-insert '"\eb":backward-word' # match emacs mode
  bind -m vi-insert '"\ef":forward-word'  # match emacs mode
fi

###############################
# Colors
###############################
# Enable true colors in terminal
export COLORTERM=truecolor

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
## Set up config home for macOS
if [ "$(uname -s)" == "Darwin" ]; then
  export XDG_CONFIG_HOME=${HOME}/.config
fi

## Set up homebrew paths if exists
[ -f /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"

## Local executable paths
[[ ":$PATH:" =~ ":${HOME}/.local/bin:" ]] || PATH="${HOME}/.local/bin:$PATH" # installed from source
[[ ":$LD_LIBRARY_PATH:" =~ ":${HOME}/.local/lib:" ]] || LD_LIBRARY_PATH="${HOME}/.local/lib${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}"
[[ ":$MANPATH:" =~ ":${HOME}/.local/man:" ]] || MANPATH=":${HOME}/.local/share/man${MANPATH:+${MATHPATH}}"
[[ ":$PATH:" =~ ":${HOME}/.cargo/bin:" ]] || PATH="${HOME}/.cargo/bin:$PATH" # rustup
[[ ":$PATH:" =~ ":${HOME}/.scripts:" ]] || PATH="${HOME}/.scripts:$PATH"     # personal scripts
export PATH LD_LIBRARY_PATH MANPATH

# Source .bashrc_local if it exists
if [ -f "$HOME/.bashrc_local" ]; then
  . "$HOME/.bashrc_local"
fi

# INFO: put source and alias after .bashrc_local because some executables are set up there
# Not sure if this will cause any side effect yet

# wezterm shell integration
# test -e "${HOME}/.config/wezterm/wezterm_shell_integration.sh" && . "${HOME}/.config/wezterm/wezterm_shell_integration.sh"

# pyenv
# place this after other PATH setup so that pyenv takes precedence over say conda base env if it is actiated by default
# higher priority than base env but lower priority than manually activated env
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH" && eval "$(pyenv init -)"

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

# atuin
# command -v atuin &>/dev/null && eval "$(atuin init bash)"

# fzf
if type fzf &>/dev/null; then
  # I tried the best to make fzf use fd, rg, bat and other better utilities when available, but some in-process keybindinds may still not work without them
  # fzf shell intergration
  eval "$(fzf --bash)"

  FZF_DEFAULT_OPTS="--color header:italic --info=inline --border none --no-separator"
  FD_DEFAULT_OPTS="--hidden --follow --no-ignore --exclude .git --strip-cwd-prefix"
  # If there's a global ignore file, use it
  [[ -f $HOME/.ignore ]] && FD_DEFAULT_OPTS+=" --ignore-file $HOME/.ignore"

  # FZF FILE WIDGET
  # Make it full screen since exiting from bat preview would clear the screen (I think it's cuz fzf process clears the lines that it uses)
  # Only way to keep the view consistent is to make it full screen
  # Ctrl-v: open file in neovim (`become` somehow doesn't work for me, execute+abort achieves the same thing)
  FZF_CTRL_T_OPTS="--walker-skip .git,node_modules,target \
                   --header 'Enter to paste, <C-v> to open in nvim, <C-t> to show files only, <C-i> to hide ignored, <C-o> to peek in bat, <C-/> to toggle preview' \
                   --bind 'ctrl-v:execute(nvim {})+abort' \
                   --bind 'ctrl-x:jump'"
  if type bat &>/dev/null && type fd &>/dev/null; then
    # ctrl-o: view file in bat, useful to quick peek and exit
    FZF_CTRL_T_OPTS+=" --preview 'bat --color=always --style=plain {}' \
                       --preview-window border-thinblock --preview-label='Preview'\
                       --bind 'ctrl-t:reload(eval \"fd $FD_DEFUALT_OPTS --type f --ignore\")' \
                       --bind 'ctrl-g:reload(eval \"fd $FD_DEFUALT_OPTS --ignore\")' \
                       --bind 'ctrl-/:change-preview-window(down|hidden|),ctrl-o:execute(bat --style=full --paging always {})'"
  fi

  # FZF CD WIDGET
  # Seems like --walker doesn't work once I use custom command.
  FZF_ALT_C_OPTS="--walker-skip .git,node_modules,target"
  if type tree &>/dev/null && type fd &>/dev/null; then
    FZF_ALT_C_OPTS+=" --preview 'tree -C {} | head -200' \
                      --header '<C-g> to hide ignored' \
                      --bind 'ctrl-g:reload(eval \"fd $FD_DEFUALT_OPTS --type d --ignore\")'"
  fi
  bind -r "\ec" # unbind default keybinding for __fzf_cd__
  bind -m emacs '"\C-s":" \C-b\C-k \C-u`__fzf_cd__`\e\C-e\er\C-m\C-y\C-h\e \C-y\ey\C-x\C-x\C-d"'
  bind -m vi-command '"\C-s": "\C-z\C-s\C-z"'
  bind -m vi-insert '"\C-s": "\C-z\C-s\C-z"'

  # FZF HISTORY WIDGET
  FZF_CTRL_R_OPTS="--header '<C-y> to copy, <C-/> to toggle preview, <M-/> to toggle line wrap' \
                   --preview 'echo {}' \
                   --preview-window down:3:hidden:wrap \
                   --bind 'ctrl-/:toggle-preview'"
  # ctrl-y to copy the command into clipboard using pbcopy
  if type pbcopy &>/dev/null; then
    FZF_CTRL_R_OPTS+=" --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'"
  fi

  export FZF_CTRL_T_OPTS FZF_CTRL_R_OPTS FZF_ALT_C_OPTS
  # extra commands to enable completion for fzf
  _fzf_setup_completion path rg ls
  _fzf_setup_completion dir tree

  if type fd &>/dev/null; then
    # Setting the default source for fzf
    # export FZF_DEFAULT_COMMAND="fd --hidden --follow --strip-cwd-prefix --type f"
    export FZF_DEFAULT_COMMAND="fd --strip-cwd-prefix"
    # shell integration doesnn't use FZF_DEFAULT_COMMAND, must set separately
    # show all ignored, hidden, link directories, except the ones excluded by ~/.ignore (making fzf in home dir faster)
    export FZF_CTRL_T_COMMAND="fd $FD_DEFAULT_OPTS"
    export FZF_ALT_C_COMMAND="fd $FD_DEFAULT_OPTS --type d"

    # Use fd for listing path candidates.
    # - The first argument to the function ($1) is the base path to start traversal
    _fzf_compgen_path() {
      fd $FD_DEFAULT_OPTS "$1"
    }

    # Use fd to generate the list for directory completion
    _fzf_compgen_dir() {
      fd --type d $FD_DEFAULT_OPTS "$1"
    }

    # Advanced customization of fzf options via _fzf_comprun function
    # - The first argument to the function is the name of the command.
    # - You should make sure to pass the rest of the arguments to fzf.
    # ideally we should check if all these utilities are available, but cannot do it cleanly here
    _fzf_comprun() {
      local command=$1
      shift

      case "$command" in
      cd) fzf --preview 'tree -C {} | head -200' "$@" ;;
      export | unset) fzf --preview "eval 'echo \$'{}" "$@" ;;
      ssh) fzf --preview 'dig {}' "$@" ;;
      *) fzf --preview 'bat -n --color=always {}' "$@" ;;
      esac
    }

    # Custom widget to nagivate anywhere in git repo
    fzf_cd_repo_widget() {
      local dir

      # Find the root of the repo. If submodule, find the root of the parent repo
      local parent_repo=$(git rev-parse --show-superproject-working-tree 2>/dev/null)
      local current_repo=$(git rev-parse --show-toplevel 2>/dev/null)
      local repo_root=${parent_repo:-$current_repo}
      if [[ -z $repo_root ]]; then
        return 0
      fi

      # Get the relative path of the current repo to the parent repo
      cur_rel_path=$(realpath --relative-to=$repo_root $current_repo)
      # Command to search for directories within the current git repo, including the root
      # . means the root of repo (since it's relative to the root, and fd only returns the child directories, not itself)
      FZF_CD_REPO_COMMAND="{ echo '.'; fd $FD_DEFAULT_OPTS --type d --base-directory $repo_root .; }"

      FZF_CD_REPO_OPTS=$(
        __fzf_defaults "--reverse --scheme=path \
                        --preview 'tree -C $repo_root/{} | head -200' \
                        --header 'Root is $(basename $repo_root). <C-o> to search in $(basename $current_repo), <C-g> to hide ignored' \
                        --bind 'ctrl-g:reload(echo .; eval \"fd $FD_DEFUALT_OPTS --ignore --type d --base-directory $repo_root . \")' \
                        --bind 'ctrl-o:reload(echo $cur_rel_path ;eval \"fd $FD_DEFUALT_OPTS --type d --base-directory $repo_root --search-path $cur_rel_path . \")' \
                        +m"
      )

      # prepend the repo root
      dir=$repo_root/$(
        FZF_DEFAULT_COMMAND=$FZF_CD_REPO_COMMAND \
          FZF_DEFAULT_OPTS=$FZF_CD_REPO_OPTS \
          FZF_DEFAULT_OPTS_FILE='' $(__fzfcmd)
      ) && printf 'builtin cd -- %q' "$(builtin unset CDPATH && builtin cd -- "$dir" && builtin pwd)"
    }
    # map to ctrl-o
    bind -m emacs '"\C-o": " \C-b\C-k \C-u`fzf_cd_repo_widget`\e\C-e\er\C-m\C-y\C-h\e \C-y\ey\C-x\C-x\C-d"'
    bind -m vi-command '"\C-o": "\C-z\C-q\C-z"'
    bind -m vi-insert '"\C-o": "\C-z\C-q\C-z"'
  else
    # fallback if fd is not available
    echo "[Warning] Installing fd is strongly recommended for fzf."
  fi

  if type rg &>/dev/null && type bat &>/dev/null; then
    # Interactive grep with preview
    # Initially using rg for exact match, Ctrl-f to switch to use fzf as secondary fuzzy filter
    # Query automatically reloads as you type
    # Extra rg options can be passed as arguments, but must proceed the query
    # Ctrl-i to show ignored files, but it's not persistent across reloads
    rgi() {
      RG_PREFIX="rg --line-number --no-heading --color=always --smart-case "
      INITIAL_QUERY="${@: -1}"
      RG_OPTS=${@:1:$#-1}
      fzf --ansi --disabled --prompt 'rg> ' --query "$INITIAL_QUERY" \
        --bind "start:reload:$RG_PREFIX $RG_OPTS {q} || true" \
        --bind "change:reload:sleep 0.1; $RG_PREFIX $RG_OPTS {q} || true" \
        --delimiter : \
        --preview 'bat --color=always {1} --highlight-line {2}' \
        --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
        --header "<Enter> to open in nvim, <C-g> to show ignored, <C-l> to switch to fuzzy find" \
        --bind "ctrl-g:reload($RG_PREFIX $RG_OPTS --no-ignore {q} || true)" \
        --bind "ctrl-l:unbind(change,ctrl-l)+change-prompt(fzf> )+enable-search+clear-query" \
        --color "hl:-1:underline,hl+:-1:underline:reverse" \
        --bind 'enter:become(nvim {1} +{2})'
    }
  fi
fi

# direnv
if command -v direnv &>/dev/null; then
  eval "$(direnv hook bash)"
fi

# Set up function for completion for aliases
# Place this after all command and default complete are sourced
# Use auto unmask to record the default completion
export COMPAL_AUTO_UNMASK=1
source ${HOME}/.scripts/complete-alias.sh

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
  alias ltree="eza --tree"
  alias lld='ll -d'
else
  alias ls='ls -F --color=auto'
  alias la='ls -A'
  alias ld='ls -d'
  alias lda='la -d'
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
if type rg &>/dev/null; then
  alias rg='rg --smart-case --hidden'
fi

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
  # ble/debug/profiler/start a
  ble-attach
  # ble/debug/profiler/stop
fi
