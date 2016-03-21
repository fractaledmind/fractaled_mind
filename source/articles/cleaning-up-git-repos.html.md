---
:title: Cleaning up Git repos
:tags: til
:date: 2016-03-15
---

### Deleting old remote branches

If you have a repository that's been around for long enough, you probably have a fair number of "stray branches": deadends, false starts, orphans, etc. Let's clean up all of the remote branches that haven't been touched in the last 6 months:

~~~bash
for k in $(git branch -r | grep -E -v '>|master|prod'); do
  if [ -z "$(git log -1 --since='6 months ago' -s $k)" ]; then
    git push origin --delete $(cut -d"/" -f2- <<< "$k");
  fi
done
~~~

Walking through the various steps:

1. `git branch -r` lists all remote branches
2. `grep -E -v '>|master|prod'` filters that list of branches, removing any that have `>` (e.g. `origin/HEAD -> origin/master`), `master` (e.g. `origin/master`), or `prod` (e.g. `origin/prod`) in their names.
3. Iterating over each of these branches (as `$k`), `git log -1 --since='6 months ago' -s $k` checks if the branch has been commited to in the last 6 months (you could obviously set the timeframe to whatever suited your needs).
4. `cut -d"/" -f2- <<< "$k")` trims a branch string like `origin/feature/some_branch` to a string like `feature/some_branch`.
5. Finally `git push origin --delete $(...)` removes that branch from the remote repository.

### Deleting already-merged remote branches

You may also find yourself needing to remove remote branches that have also already been merged to `master`.

~~~bash
git branch -r --merged origin/master
| grep -E -v '>|master|prod'
| cut -d"/" -f2-
| xargs git push origin --delete
~~~

Here we see many of the same basic sub-commands we used before. There is, however, one note-worthy difference. We specify the specific branch we want to check whether the remote branches have been merged into by specifying `origin/master`. This ensures that only remote branches that have been merged into remote `master` are passed to the next sub-command.

### Deleting already-merged local branches

Finally, if you need to clean up your local repository, you can prune the local branches that have already been merged into `master` in a similar way:

~~~bash
git branch -d $(git branch --merged master | grep -E -v '\*|master|prod')
~~~

A word of warning though: have local copies of these branches somewhere, just in case you delete a branch you want back at some point ;)
