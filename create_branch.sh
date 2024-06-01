#!/bin/bash
create_branch() {
local prefix="${prefix}/${name}"
if ! git show-ref --verify --quiet refs/heads/development; then
echo ":: Development branch does not exist. Exiting."
exit 1
fi
git checkout development
git pull origin development
git checkout -b "$branch_name"
git push -u origin "$branch_name"
echo ":: Branch  created and pushed to remote."
}
if [ "$#" -ne 1 ]; then
echo ":: Usage: $0 [feature|bugfix]"
exit 1
fi
type=$1
echo ":: Enter the branch name:"
read name
create_branch "$type" "$name"
