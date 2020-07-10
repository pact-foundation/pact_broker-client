#!/bin/sh
set -e

# bundle exec rake
bundle exec bump ${1:-minor} --no-commit
bundle exec rake generate_changelog
git add CHANGELOG.md lib/pact_broker/client/version.rb
git commit -m "Releasing version $(ruby -r ./lib/pact_broker/client/version.rb -e "puts PactBroker::Client::VERSION")"
bundle exec rake release
