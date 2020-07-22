
## Bare Git Repo

## Branch Organization
Branches are organized in the following fashion: master branch contains all base files that are shared among all systems. Each system has its own branch, if necessary. Local-specific files will only be contained in system-specific branches.

Shared files should be committed in the master branch. In system-specific branches, sync in the changes in master by running ```dgit rebase master```.

One minor issue to this method is, after switching from system-specific branches to master branch, the files which are only tracked in system-specific branches will be removed from the working tree. This may cause trouble if you perform certain activities in the master branch. Therefore, it is recommended to stay in system-specific branches for most of the work, and only switch to master branch when you commit the changes.
