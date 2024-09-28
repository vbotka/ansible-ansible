#! /usr/bin/bash

repository=$1

git push
status=$?

echo "{$repository: {rc: $status}}"
