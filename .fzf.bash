# I tried the best to make fzf use fd, rg, bat and other better utilities when available while supporting fallback,
# but some in-process keybindinds may still not work without them

FZF_DEFAULT_OPTS="--style full --ansi \
  --color 'border:#aaaaaa,label:#cccccc' \
  --color 'preview-border:#9999cc,preview-label:#ccccff' \
  --color 'list-border:#669966,list-label:#99cc99' \
  --color 'input-border:#996666,input-label:#ffcccc' \
  --color 'header-border:#6699cc,header-label:#99ccff'"

FD_DEFAULT_OPTS="--hidden --follow --no-ignore --exclude .git --strip-cwd-prefix"
# If there's a global ignore file, use it
[[ -f $HOME/.ignore ]] && FD_DEFAULT_OPTS+=" --ignore-file $HOME/.ignore"

# Use bat for full-screen preview if available
if type bat &>/dev/null; then
  PREVIEW_CMD="bat --style=full --paging=always"
else
  PREVIEW_CMD="less"
fi

# FZF FILE WIDGET
# Ctrl-v: open file in neovim (`become` somehow doesn't work for me, execute+abort achieves the same thing)
# ctrl-o: view file in bat or less, useful to quick peek and exit
FZF_CTRL_T_OPTS="--walker-skip .git,node_modules,target \
      --header 'Enter to paste, <C-v> to open in nvim, <C-t> to show files only, <C-g> to hide ignored, <C-o> to peek, <C-/> to toggle preview, <M-/> to toggle wrap' \
      --preview 'fzf-preview.sh {}' \
      --preview-label='Preview' \
      --bind 'ctrl-v:execute(nvim {})+abort' \
      --bind 'ctrl-/:toggle-preview,ctrl-o:execute($PREVIEW_CMD {})' \
      --bind 'ctrl-x:jump'"

if type fd &>/dev/null; then
  FZF_CTRL_T_OPTS+=" --bind 'ctrl-t:reload(eval \"fd $FD_DEFUALT_OPTS --type f --ignore\")' \
              --bind 'ctrl-g:reload(eval \"fd $FD_DEFUALT_OPTS --ignore\")'"
fi

# FZF CD WIDGET
# Seems like --walker doesn't work once I use custom command.
FZF_ALT_C_OPTS="--walker-skip .git,node_modules,target"
if type tree &>/dev/null && type fd &>/dev/null; then
  FZF_ALT_C_OPTS+=" --preview 'tree -C {} | head -200' \
        --header '<C-g> to hide ignored, <C-/> to toggle preview, <M-/> to toggle wrap' \
        --bind 'ctrl-/:toggle-preview' \
        --bind 'ctrl-g:reload(eval \"fd $FD_DEFUALT_OPTS --type d --ignore\")'"
fi

# FZF HISTORY WIDGET
FZF_CTRL_R_OPTS="--header '<C-y> to copy, <C-/> or <M-/> to toggle wrap' \
      --preview 'echo {}' \
      --preview-window up:3:hidden:wrap"
# ctrl-y to copy the command into clipboard using pbcopy
if type pbcopy &>/dev/null; then
  FZF_CTRL_R_OPTS+=" --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'"
fi

export FZF_CTRL_T_OPTS FZF_CTRL_R_OPTS FZF_ALT_C_OPTS

if type fd &>/dev/null; then
  # Setting the default source for fzf
  # export FZF_DEFAULT_COMMAND="fd --hidden --follow --strip-cwd-prefix --type f"
  export FZF_DEFAULT_COMMAND="fd --strip-cwd-prefix"
  # shell integration doesnn't use FZF_DEFAULT_COMMAND, must set separately
  # show all ignored, hidden, link directories, except the ones excluded by ~/.ignore (making fzf in home dir faster)
  export FZF_CTRL_T_COMMAND="fd $FD_DEFAULT_OPTS"
  export FZF_ALT_C_COMMAND="fd $FD_DEFAULT_OPTS --type d"

  # Advanced customization of fzf options via _fzf_comprun function
  # - The first argument to the function is the name of the command.
  # - You should make sure to pass the rest of the arguments to fzf.
  # ideally we should check if all these utilities are available, but cannot do it cleanly here
  # _fzf_comprun() {
  #   local command=$1
  #   shift
  #
  #   case "$command" in
  #     cd) fzf --preview 'tree -C {} | head -200' "$@" ;;
  #     export | unset) fzf --preview "eval 'echo \$'{}" "$@" ;;
  #     ssh) fzf --preview 'dig {}' "$@" ;;
  #     *) fzf --preview 'bat -n --color=always {}' "$@" ;;
  #   esac
  # }

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
        --header 'Root is $(basename $repo_root). <C-o> to search in $(basename $current_repo), <C-g> to hide ignored, <C-/> to toggle preview, <M-/> to toggle wrap' \
        --bind 'ctrl-/:toggle-preview' \
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
fi

if type rg &>/dev/null && type bat &>/dev/null; then
  # Interactive grep with preview
  # Initially using rg for exact match, Ctrl-f to switch to use fzf as secondary fuzzy filter
  # Query automatically reloads as you type
  # Extra rg options can be passed as arguments, but must proceed the query
  # Ctrl-g to show ignored files, but it's not persistent across reloads
  # TODO: use fzf-preview.sh for preview. Still don't know how to pass in params
  rgi() {
    RG_PREFIX="rg --line-number --no-heading --color=always --smart-case "
    INITIAL_QUERY="${@: -1}"
    RG_OPTS=${@:1:$#-1}
    fzf --style full \
      --color 'border:#aaaaaa,label:#cccccc' \
      --color 'preview-border:#9999cc,preview-label:#ccccff' \
      --color 'list-border:#669966,list-label:#99cc99' \
      --color 'input-border:#996666,input-label:#ffcccc' \
      --color 'header-border:#6699cc,header-label:#99ccff' \
      --ansi --disabled --prompt 'rg> ' --query "$INITIAL_QUERY" \
      --bind "start:reload:$RG_PREFIX $RG_OPTS {q} || true" \
      --bind "change:reload:sleep 0.1; $RG_PREFIX $RG_OPTS {q} || true" \
      --delimiter : \
      --preview 'bat --color=always {1} --highlight-line {2}' \
      --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
      --header "<Enter> to open in nvim, <C-g> to show ignored, <C-l> to switch to fuzzy find, <C-/> or <M-/> to toggle wrap" \
      --bind "ctrl-g:reload($RG_PREFIX $RG_OPTS --no-ignore {q} || true)" \
      --bind "ctrl-l:unbind(change,ctrl-l)+change-prompt(fzf> )+enable-search+clear-query" \
      --color "hl:-1:underline,hl+:-1:underline:reverse" \
      --bind 'enter:become(nvim {1} +{2})'
  }
fi

fzf_bind_cd_widget() {
  # bind to ctrl-s instead
  bind -r "\ec" # unbind default keybinding for __fzf_cd__

  if [[ ${BLE_VERSION-} ]]; then
    ble-bind -m emacs -c C-s 'ble/util/eval-stdout "__fzf_cd__"'
    ble-bind -m vi_imap -c C-s 'ble/util/eval-stdout "__fzf_cd__"'
    ble-bind -m vi_nmap -c C-s 'ble/util/eval-stdout "__fzf_cd__"'
  else
    bind -m emacs '"\C-s": " \C-b\C-k \C-u`__fzf_cd__`\e\C-e\er\C-m\C-y\C-h\e \C-y\ey\C-x\C-x\C-d"'
    bind -m vi-command '"\C-s": "\C-z\C-s\C-z"'
    bind -m vi-insert '"\C-s": "\C-z\C-s\C-z"'
  fi
}

fzf_bind_cd_repo_widget() {
  # map to ctrl-o
  if [[ ${BLE_VERSION-} ]]; then
    ble-bind -m emacs -c C-o 'ble/util/eval-stdout "fzf_cd_repo_widget"'
    ble-bind -m vi_imap -c C-o 'ble/util/eval-stdout "fzf_cd_repo_widget"'
    ble-bind -m vi_nmap -c C-o 'ble/util/eval-stdout "fzf_cd_repo_widget"'
  else
    bind -m emacs '"\C-o": " \C-b\C-k \C-u`fzf_cd_repo_widget`\e\C-e\er\C-m\C-y\C-h\e \C-y\ey\C-x\C-x\C-d"'
    bind -m vi-command '"\C-o": "\C-z\C-q\C-z"'
    bind -m vi-insert '"\C-o": "\C-z\C-q\C-z"'
  fi
}
