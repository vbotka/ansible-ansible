#! /usr/bin/bash

repository=$1

revision=$(git rev-list --tags --max-count=1)
tag=$(git describe --tags "$revision")

echo "{$repository: $tag}"
