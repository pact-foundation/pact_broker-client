#!/bin/sh
set -e

tag=$(cat CHANGELOG.md  | grep "#" | head -n 1 | cut -d' ' -f2)
mkdir -p tmp
git diff CHANGELOG.md | grep "^+" | grep -v "b/CHANGELOG.md" | sed 's/^+//g' > tmp/RELEASE_NOTES.md
echo "::set-env name=TAG::${tag}"