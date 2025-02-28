#! /usr/bin/env bash
#************************
# Modify these variables
#************************
PREFIX=${HOME}/.local
CONDA_HOME=${HOME}/.conda

##### Set up dotfiles #####
git clone --separate-git-dir=$HOME/.dotfiles.git https://github.com/allpan3/dotfiles.git dotfiles-tmp
rsync --recursive --verbose dotfiles-tmp/ $HOME/
rm -rf dotfiles-tmp
git checkout nonroot
git config status.showUntrackedFiles no
# Refresh
source .bashrc

##### Install package managers #####
# conda
curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
bash Miniforge3-$(uname)-$(uname -m).sh -b -p $CONDA_HOME
rm -f Miniforge3-$(uname)-$(uname -m).sh

# Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --no-modify-path -y

# ble.sh
mkdir ${PREFIX}/source
pushd ${PREFIX}/source
git clone --recursive https://github.com/akinomyoga/ble.sh.git
cd ble.sh
make && make install
popd

# Refresh
source .bashrc

# Set up conda
conda config --set changeps1 False

##### Install software #####
# neovim
conda install nvim nodejs ripgrep

# Zellij
cargo install zellij

# Other utilities
conda install fzf fd-find bat zoxide btop eza starship 

# Environment management
conda install direnv

# Git
conda install git gh git-delta lazygit

# C/C++ development
conda install bear

# GPU
conda install nvtop

# Refresh
source .bashrc


