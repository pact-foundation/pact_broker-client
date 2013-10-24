#!/bin/bash
set -e

RUBY_VERSION=1.9.3-p194

eval $( curl http://dist/rea/toolchain/ruby-env-rbenv-polite | bash -s $RUBY_VERSION )
rbenv local $RUBY_VERSION
bundle config --delete path
bundle config --delete without
bundle install && bundle exec rake "$@"
