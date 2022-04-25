
### This file is shared between systems. Put any localization features in .cshrc_local

# If not running interactively, don't do anything
if ($?USER == 0 || $?prompt == 0) exit

######### Shell Setup ##########
# Disable "Ctrl-D" to log out
set ignoreeof

# set number of history of each individual shell.
set history=2048

# Make sure that there is no logging of the session.
# Privacy issues and it was mentioned that logging makes slow the logout
unset histfile

# If the autolist shell variable is set, the shell lists the remaining choices (if any) whenever completion fails:
# example:
# % ls /usr/lib/libt[tab]
# % libtermcap.a libtermlib.a
# % nm /usr/lib/libterm
set autolist

# Do autocorrection while completing...
# It does some very rudimentary corrections. I was not disatisfied yet.
# example:
# % cd /usr/loca/bin<TAB>
# % cd /usr/local/bin     <- you get
set autocorrect

# Use the history of commands to aid expansion.
set autoexpand

set complete=enhance

# ignore: not resolve symlink to real path when cd 
set symlinks=ignore


# Ask for confirmation when 'rm *'.
set rmstar


# Files that are to be ignored from completion.
# .o: files that GCC produces. Usually you do not touch them.
set fignore=(.o)

########## Variables ##########
# "set -f" adds a variable in _front of the list, keep one copy
# "set -l" adds a variable at the end(_last) of the list, keep one copy
setenv EMACS_SERVER_DIR /tmp/emacs-allpan # the custom directory for TCP and Socket server

########## Aliases ##########
alias his history
alias ls "ls -F --color=auto"
alias la "ls -A"
alias ll "la -l"
alias llt "ll -t"
alias ld  "ls -ld"
alias grep 'grep --color=auto'
alias zgrep 'zgrep --color=auto'
alias fgrep 'fgrep --color=auto'
alias egrep 'egrep --color=auto'
alias dgit 'git --git-dir=$HOME/.dotfiles.git --work-tree=$HOME'
alias tatt "tmux -CC attach -t"
alias tnew "tmux -CC new -s" 
alias tkill "tmux kill-session -t"
alias cp "cp -v"
alias mv "mv -v"
alias ff 'find . -name $*'

########## bindkey ##########
bindkey "\e[1;1D" beginning-of-line
bindkey "\e[1;1C" end-of-line
bindkey "\e[1;3D" backward-word
bindkey "\e[1;3C" forward-word
bindkey "\e[30~" backward-kill-line   
bindkey "\e[31~" kill-line 
bindkey "\e[p" yank          # this affects kill-region
bindkey "\e[M" set-mark-command
bindkey "\e[y" copy-region-as-kill
# backward-kill-line has no default keybinding; ^w is kill-region, which has the same effect when no mark is set
# but don't know how to have keybinding in tclsh now, so I have to map ^w to cmd-backspace;
# and to make cmd-backspace trigger backward-kill-line, have to bind ^w to it. In tclsh, do not use yank
bindkey "^w" backward-kill-line
# csh has no undo/redo


# .cshrc_local if it exists
if ( -f "$HOME/.cshrc_local" ) then
    source "$HOME/.cshrc_local"
endif


# Ideally this should be in .login, but csh is not the login shell for some systems.
# Don't see an issue putting here yet. Put at the end becasuse this script modifies prompt
setenv ITERM_ENABLE_SHELL_INTEGRATION_WITH_TMUX YES
source ${HOME}/.iterm2/iterm2_shell_integration.tcsh
