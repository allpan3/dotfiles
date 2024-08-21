# dotfiles
Manage dotfiles across multiple systems using different branches in a single git repository. Keeping all files in place, avoiding the need to create symlinks. Unlike a bare repo, no alias is needed and works in neovim telescope and lazygit.

## Install on a New Machine
```
# Clone the repo to a named git directory and work tree
git clone --separate-git-dir=$HOME/.dotfiles.git https://github.com/allpan3/dotfiles.git dotfiles-tmp
# Move all files in the work tree over to your home directory
rsync --recursive --verbose dotfiles-tmp/ $HOME/
# Remove the temporary directory
rm -rf dotfiles-tmp
# Hide untracked files
git config status.showUntrackedFiles no
```
A `.git` file resides in the work tree, which contains a pointer to the actual git directory.
Next, checkout the system-specific branch that you would like to install.
```
git checkout <branch>
```
If this is a new type of machine to set up, create a new branch for it.
```
git checkout -b <branch>
```
Start a new shell to allow settings to take effect.

## Branch Organization
Branches are organized in the following fashion: `master` branch contains all base files that are shared among all systems. Each system has its own branch where system-specific files *plus* all files from `master` are stored. Multiple systems may share one system-specific branch if not significantly different. 

Shared files should always be committed in the `master` branch. In system-specific branches, sync the changes in `master` by running `dgit rebase master`.
If shared files are accidentally added and committed in a system-specific branch, use `dgit cherry-pick` to migrate them to the `master` branch. This is important for keeping rebase simple.

One minor issue with this method is, after switching from system-specific branches to `master` branch, the files which are only tracked in system-specific branches will be removed from the working tree. This may cause trouble if you perform certain activities in the `master` branch that look for some files exclusive to the system-specific branch. Therefore, it is recommended to stay in system-specific branches for most of the work, and only switch to `master` branch when you need to commit changes.

## Manage Multiple Systems
There are a few ways to manage system-specific settings. Not all of them are available for a given configuration context. Here are some methods that work in conjunction with the [branch organization](#branch-organization), listed in the order of easiness to sync between machines.

1. Use condition statements based on `$(uname -s)` or `$(hostname)` to separate out system-specific settings within the same configuration file. This guarantees synchronization and no conflict, not the configuration may get messy.

2. Create system-specific "sub-files", conventionally named "`xxx_local`" to store system-specific settings, and include/source them in the main configuration files. Store these local files in system-specific branches.

3. Having separate versions of configuration files and store each in its own system-specific branch. 
    - This differs from 2 in that the shared part is contained in the same file, instead of being in a separate base version. This is most often needed when separating the config into multiple files is infeasible.
    - We can still have a base version of the file stored in `master`, which contains the shared part, and the system-specific versions will just write modification on top of that. But, must be careful that there's no conflict between them, otherwise conflict-resolving will be required every time you rebase.
    - If no base version is stored in `master` branch, then we must remember to update the same changes in every system-specific branch, if that change is common to all of them. This creates extra hassle in the synchronization process.

When a configuration file is only expected to reside in a single system-specific branch, then there won't be synchronization issue - simply add it in its own repo only.

### Push System-Specific Branch to Remote Repo
If we exclusively use rebase to synchronize the `master` branch into system-specific branches, the commit history will be changed every time and force push is required. This is generally okay since dotfiles.git generally doesn't involve collaboration.

### Pull System-Specific Branch from Remote Repo
Since remote repo history has been rewritten by rebase, we also need to pull with rebase.
```
git pull origin --rebase
```
