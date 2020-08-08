
## Bare Git Repo

## Branch Organization
Branches are organized in the following fashion: `master` branch contains all base files that are shared among all systems. If necessary, each system can have its own branch, where only system-specific local files are committed. Multiple systems can share one system-specific branch if that's sufficient.

Whenever possible, use "include" syntax to separate out system-specific settings into local files, conventionally named "`xxx.local`", and then commit those files into the system-specific branch.

Sometimes it may not be possible to separate out settings in the aforementioned way. In those cases, in those cases, try use `if-else` statement to control execution based on hostname. If that is still not possible, commit the entire file to system-specific branch. (This introduces extra hassle in syncing between systems, so remember to add any common lines in all branches.)

Since we hide all untracked files, `dgit status` will only show the tracked files that are modified.  In the earlier stage when the file tree is not settled (meaning new files are constantly being added to the repo), extra attention needs to be given in order not to commit files to the wrong branch. After the file tree is stabilized, we just need to add whatever shown in `dgit status` (or do `dgit commit -a`), and the files will always go to the correct branch. This is what I consider the advantage of this branch organization.

When pulling changes from the repo, make sure to pull from both `master` and the system-specific branch. 

