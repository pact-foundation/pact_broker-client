#!/bin/sh

set -eu

bundle exec bin/pact-broker record-deployment \
   --pacticipant "Pact Broker Client" --version $GITHUB_SHA \
   --environment production
