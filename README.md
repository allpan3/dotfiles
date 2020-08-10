
## Bare Git Repo

## Branch Organization
Branches are organized in the following fashion: `master` branch contains all base files that are shared among all systems. Each system, if necessary, has its own branch where system-specific files plus all files from `master` are stored. Multiple systems can share one system-specific branch if that's sufficient. 

Shared files should be committed in the `master` branch. In system-specific branches, sync in the changes in `master` by running `dgit rebase master`.
If shared files are accidentally added and committed in a system-specific branch, use `dgit cherry-pick` to migrate them to the `master` branch.

One minor issue with this method is, after switching from system-specific branches to `master` branch, the files which are only tracked in system-specific branches will be removed from the working tree. This may cause trouble if you perform certain activities in the `master` branch. Therefore, it is recommended to stay in system-specific branches for most of the work, and only switch to `master` branch when you commit the changes.

## Manage Multiple Systems

There are a few ways to manage system-specific settings. Not all of them are available for a given configuration context. Here are some methods that work in conjunction with the [branch organization](#branch-organization), listed in the order of ease to sync. It is the best to apply the first-ever possible rule.

1. Use condition statements based on `$(uname)` or `$(hostname)` to separate out system-specific settings within the same configuration file.

2. Create system-specific "sub-files", conventionally named "`xxx.local`" to store system-specific settings, and include/source them in the main configuration files. Store these local files in system-specific branches.
3. Having separate versions of a configuration file and store each in a different system-specific branch. 

    - There can still be a base version of the file stored in `master` for any systems without special settings to use, as well as storing the common part to allow syncing through rebasing. But, must be careful that there's no conflict with the system-specific versions, otherwise conflict-resolving will be required every time you do `dgit rebase`.

    - If no base version is stored in `master` branch, must remember to add any common changes in all of the branches. This creates extra hassle in the syncing process.

