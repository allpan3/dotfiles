
# Source .bash_profile_local first if it exists
if [ -f "$HOME/.bash_profile_local" ]; then
    . "$HOME/.bash_profile_local"
fi

if [ -n "$BASH_VERSION" ]; then
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi

