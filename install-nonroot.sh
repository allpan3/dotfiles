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

# Refresh
source .bashrc

# Set up conda
conda config --set changeps1 False

##### Install software #####
# Neovim
conda install nvim nodejs ripgrep

# Cargo crates
cargo install zellij
cargo install cargo-update

# Utilities
conda install fzf fd-find bat zoxide eza starship \
      procs btop dust sd tokei direnv

# Git
conda install git gh git-delta lazygit

# C/C++ development
conda install bear

# GPU
conda install nvtop

##### Install from Source #####
mkdir -p ${PREFIX}/source
mkdir -p ${PREFIX}/share
mkdir -p ${PREFIX}/bin

# ble.sh
pushd ${PREFIX}/source
git clone --recursive https://github.com/akinomyoga/ble.sh.git
cd ble.sh
make && make install
popd

