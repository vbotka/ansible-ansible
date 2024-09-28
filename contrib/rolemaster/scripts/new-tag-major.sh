#! /usr/bin/bash

repository=$1

revision=$(git rev-list --tags --max-count=1)
tag=$(git describe --tags "$revision")
IFS='.' read -r -a tag_bits <<<"$tag"

vnum1=${tag_bits[0]}

new1=$((vnum1+1))
tag_new="$new1.0.0"

echo "{$repository: $tag_new}"
