#!/bin/sh
set -e

tag=$(git describe)
mkdir -p tmp
git diff CHANGELOG.md | grep "^+" | grep -v "b/CHANGELOG.md" | sed 's/^+//g' > tmp/RELEASE_NOTES.md
echo "::set-env name=TAG::${tag}"