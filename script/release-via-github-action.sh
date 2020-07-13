#!/bin/sh
set +e

git tag -d release
git push --delete origin release
git tag -a release
git push origin release
