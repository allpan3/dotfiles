### This file is shared between systems. Put any localization features in .bashrc_local

## Variables
export PS1="\[\e[30;42m\][\w]\[\e[m\]\[\e[32m\] $\[\e[m\] "
export PATH="~/.scripts:$PATH:/usr/local/sbin"
export CPATH="/usr/local/include"
export LIBRARY_PATH="/usr/local/lib"
export EDITOR="$HOME/.scripts/em.sh -nw"  # seems like env vars are not able to resolve alias

## Options
# cdable_vars: an argument to the cd builtin command that is not a directory is assumed to be the name of a variable whose value is the directory to change to.
shopt -s cdable_vars
shopt -s cdspell
shopt -s dirspell direxpand

## Aliases
alias cd='cd ' # with this, shell will sub the alias after cd
alias ls='ls -GF'
alias la='ls -A'
alias ll='la -lh'
alias ld='ls -d' # list directories not their contents; usually following wildcards; compare this to ls followed a directory name
alias grep='grep --color=auto'
alias emacs='emacs -daemon'
alias em='~/.scripts/em.sh'     # default, sends to the existing client
alias ec='~/.scripts/em.sh -nw' # open another client
alias dotgit='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'


## Sources 
export BASH_COMPLETION_COMPAT_DIR="/usr/local/etc/bash_completion.d"
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"
complete -o nospace -f -F _cd cd # overwrite cd behavior

test -r "/usr/local/etc/profile.d/z.sh" && . /usr/local/etc/profile.d/z.sh

export ITERM_ENABLE_SHELL_INTEGRATION_WITH_TMUX=YES
test -e "${HOME}/.iterm2/iterm2_shell_integration.bash" && source "${HOME}/.iterm2/iterm2_shell_integration.bash"


if [ -f "$HOME/.ssh/id_rsa" ]; then
    . "$HOME/.scripts/ssh-agent-setup.sh"
fi


# .bashrc_local if it exists
if [ -f "$HOME/.bashrc_local" ]; then
    . "$HOME/.bashrc_local"
fi

