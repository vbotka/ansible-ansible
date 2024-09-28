#! /usr/bin/bash

repository=$1

branch=$(git branch --show-current)

if [ "$branch" != "master" ]; then
    git switch -q master
fi

echo "{$repository: {from: $branch, to: master}}"
