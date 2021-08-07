#!/bin/bash

# Use this to stop unnecessary verifications from running when triggered by the
# `contract_content_changed` webhook, or when using the webhookless flow.

set -eu

PACT_CLI_VERSION="0.47.0.0"

: "${PACT_URL:?PACT_URL is not set, cannot run verification.}"
: "${CONSUMER_NAME:?CONSUMER_NAME is not set, cannot check if verification is required.}"
: "${CONSUMER_VERSION_NUMBER:?CONSUMER_VERSION_NUMBER is not set, cannot check if verification is required.}"

# Delete unnecessary username/password/token
if docker run --rm \
    -e PACT_BROKER_BASE_URL \
    -e PACT_BROKER_TOKEN \
    -e PACT_BROKER_USERNAME \
    -e PACT_BROKER_PASSWORD \
    -e PACT_BROKER_FEATURES="verification_required" \
    -it \
    pactfoundation/pact-cli:$PACT_CLI_VERSION \
      broker verification-required \
      --pacticipant pactflow-application-saas \
      --version ${RELEASE_VERSION} \
      --pacticipant ${CONSUMER_NAME} \
      --version ${CONSUMER_VERSION_NUMBER} \
      --verbose ; then
  echo "Run the verification here"
fi
