#!/bin/sh

set -eu

bundle exec bin/pact-broker record-release \
   --pacticipant "Pact Broker Client" --version $GITHUB_SHA \
   --environment production
