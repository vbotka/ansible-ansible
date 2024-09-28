#! /usr/bin/bash

repository=$1

revision=$(git rev-list --tags --max-count=1)
tag=$(git describe --tags "$revision")
IFS='.' read -r -a tag_bits <<<"$tag"

vnum1=${tag_bits[0]}
vnum2=${tag_bits[1]}

new2=$((vnum2+1))
tag_new="$vnum1.$new2.0"

echo "{$repository: $tag_new}"
