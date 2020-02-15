# git-quick

_git-quick_ — edit a subset of files from a git repository on any branch without affecting your working copy and without needing to do a full checkout of the branch.

It uses a mix of `git worktree` and sparse-checkout to allow edits of a subset of files in another branch without the need to `git stash` your work-in-progress. For example, you can cherry-pick a change from a branch to another without checking out the other branch and without affecting your working copy.  
The main goal is to help dealing with very large git repositories, in which case commands like `git checkout` and `git stash` take a significant amount of time to execute.

_Note: you need git 2.9.0 or later to use this tool_

## Usage

    usage: git quick create <branch>
           git quick cherry-pick <commit-ish> <branch>
           git quick add <file> <...>
           git quick del <file> <...>
           git quick status
           git quick done

`create`: creates a new worktree with the specified branch and enables sparse-checkout with no-files checked-out. You can then use `git quick add` to add files to be checked-out.  
`cherry-pick`: creates a new worktree and checks out the files modified in the specified commit and starts a cherry-pick.  
`add`: adds a file to be checked-out.  
`del`: removes a file from the checkout.  
`status`: provides a faster `git status` by showing only changes to files added to the checkout.  
`done`: deletes a worktree directory and it's associated branch and metadata.  

## Install/Update

`source <(curl -s "https://raw.githubusercontent.com/qwertzguy/git-quick/master/install.sh")`

## Examples

### Cherry-picking a change from one branch to another with a conflict

    $> pwd
    /home/gaspardvk/my_repo
    $> git quick cherry-pick abcdef release/1.0.0
    Branch release/1.0.0-cherry-pick-1 set up to track remote branch release/1.0.0 from origin.
    Preparing ../my_repo-cherry-pick-1 (identifier my_repo-cherry-pick-1)
    Checking out files...
    Cherry-picking... (this might take longer than usual)
    error: could not apply abcdef... Fixed a bug
    hint: after resolving the conflicts, mark the corrected paths
    hint: with 'git add <paths>' or 'git rm <paths>'
    hint: and commit the result with 'git commit'
    
    Done. Remember to change directory: cd ../my_repo-cherry-pick-1
    Then you can edit the cherry-pick and resolve conflicts
    Before pushing, you might want to rename the branch using: git branch -m <new_name>
    When you are done, you can run cleanup using: git quick done
    $> cd ../my_repo-cherry-pick-1
    $> vim conflicted_file.txt
    $> git add conflicted_file.txt
    $> git cherry-pick --continue
    $> git branch -m fix/a_bug_cp_release
    $> git push
    $> git quick done
    This will delete the directory '/home/gaspardvk/my_repo-cherry-pick-1' and the local branch 'fix/a_bug_cp_release'.
    Continue? [y/N] y
    Deleted directory /home/gaspardvk/my_repo-cherry-pick-1
    Deleted branch fix/a_bug_cp_release (was ghijkl).
    
    Done. Remember to change directory: cd /home/gaspardvk/my_repo
    $> cd -

### Editing a specific file from a PR of someone else

    $> pwd
    /home/gaspardvk/my_repo
    $> git quick create feature/a_feature_from_bob
    Branch feature/a_feature_from_bob set up to track remote branch feature/a_feature_from_bob from origin.
    Preparing ../my_repo-quick-1 (identifier my_repo-quick-1)
    
    Done. Remember to change directory: cd ../my_repo-quick-1
    Then you can add files to edit using git quick add <file>
    Use git quick status instead of git status. If you create a new file, use git quick add <file> to make it appear in the status
    Before pushing, you might want to rename the branch using: git branch -m <new_name>
    When you are done, you can run cleanup using: git quick done
    $> git quick add file_that_needs_an_edit.txt
    $> vim file_that_needs_an_edit.txt
    $> git add -u
    $> git commit
    $> git push
    $> git quick done
    This will delete the directory '/home/gaspardvk/my_repo-quick-1' and the local branch 'feature/a_feature_from_bob'.
    Continue? [y/N] y
    Deleted directory /home/gaspardvk/my_repo-quick-1
    Deleted branch feature/a_feature_from_bob (was 123456).
    
    Done. Remember to change directory: cd /home/gaspardvk/my_repo
    $> cd -

### Editing a specific file from a branch without affecting your current working copy

The workflow is the same as the example above, but you would use `git quick create develop` for example and rename the local branch.

## License

> MIT License
> 
> Copyright (c) 2016 Gaspard van Koningsveld
> 
> Permission is hereby granted, free of charge, to any person obtaining a copy
> of this software and associated documentation files (the "Software"), to deal
> in the Software without restriction, including without limitation the rights
> to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
> copies of the Software, and to permit persons to whom the Software is
> furnished to do so, subject to the following conditions:
> 
> The above copyright notice and this permission notice shall be included in all
> copies or substantial portions of the Software.
> 
> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
> IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
> FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
> AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
> LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
> OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> SOFTWARE.
