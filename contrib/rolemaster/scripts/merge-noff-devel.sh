#! /usr/bin/bash

repository=$1

git merge --no-ff -m "Merge devel." devel
status=$?

echo "{$repository: {rc: $status}}"
