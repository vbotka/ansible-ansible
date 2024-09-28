#! /usr/bin/bash

repository=$1
message=${2:-RoleMaster commit}
tagname=${3:-0.0.1}

git tag -s -m "$message" "$tagname"
status=$?

echo "{$repository: {rc: $status}}"
