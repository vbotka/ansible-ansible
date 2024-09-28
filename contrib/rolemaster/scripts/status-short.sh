#! /usr/bin/bash

repository=$1

modifications=$(git status -s | tr '\n' ',')

echo "{$repository: [$modifications]}"
