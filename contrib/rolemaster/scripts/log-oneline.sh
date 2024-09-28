#! /usr/bin/bash

repository=$1
format=${2:=dict}

commits=$(git log origin..HEAD --format=%s)

if [ "$format" = "dict" ]; then
    echo "{$repository: $commits}"
else
    echo "$commits"
fi
