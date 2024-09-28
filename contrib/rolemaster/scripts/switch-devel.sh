#! /usr/bin/bash

repository=$1

branch=$(git branch --show-current)

if [ "$branch" != "devel" ]; then
    git switch -q devel
fi

echo "{$repository: {from: $branch, to: devel}}"
