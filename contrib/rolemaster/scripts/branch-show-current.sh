#! /usr/bin/bash

repository=$1

branch=$(git branch --show-current)

echo "{$repository: $branch}"
