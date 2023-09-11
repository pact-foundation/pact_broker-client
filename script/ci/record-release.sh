#!/bin/sh

set -Eeuxo pipefail

bundle exec bin/pact-broker record-deployment \
   --pacticipant "Pact Broker Client" --version $GITHUB_SHA \
   --environment production
