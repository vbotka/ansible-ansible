#! /usr/bin/bash

repository=$1
message=${2:-RoleMaster commit}

git add .
git commit -a -S -m "$message"
git push
status=$?

echo "{$repository: {rc: $status}}"
