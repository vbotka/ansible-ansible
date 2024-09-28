#! /usr/bin/bash

repository=$1

git push --tags
status=$?

echo "{$repository: {rc: $status}}"
