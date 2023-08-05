#!/usr/bin/env nu

# Remove any local git branch no longer being tracked in origin / remote repo.

git branch -vl | lines | split column " " BranchName Hash Status --collapse-empty | where Status == '[gone]' | each { |it| git branch -D $it.BranchName }
