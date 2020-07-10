#!/bin/sh
set -e

# bundle exec rake
increment={INCREMENT:-patch}
bundle exec bump ${increment} --no-commit
bundle exec rake generate_changelog
version_file=$(bundle exec bump file --value-only)
version=$(bundle exec bump current --value-only)
git add CHANGELOG.md "${version_file}"
git commit -m "chore(release): version ${version}"
