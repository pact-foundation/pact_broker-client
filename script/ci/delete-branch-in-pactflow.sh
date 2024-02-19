#!/bin/bash

set -Eeuo pipefail

echo "Deleting branch ${GIT_BRANCH} for ${PACTICIPANT} in Pactflow..."
ENCODED_GIT_BRANCH=$(echo "$GIT_BRANCH" | ruby -e "require 'erb'; puts ERB::Util.url_encode(ARGF.read.chomp)")
ENCODED_PACTICIPANT=$(echo "$PACTICIPANT" | ruby -e "require 'erb'; puts ERB::Util.url_encode(ARGF.read.chomp)")
BRANCH_URL="${PACT_BROKER_BASE_URL}/pacticipants/${ENCODED_PACTICIPANT}/branches/${ENCODED_GIT_BRANCH}"

output_file=$(mktemp)

status=$(curl -v -X DELETE "${BRANCH_URL}" -H "Authorization: Bearer ${PACT_BROKER_TOKEN}" 2>&1 | tee "${output_file}" | awk '/^< HTTP/{print $3}')

if [ "$status" = "404" ]; then
  echo "Branch ${GIT_BRANCH} for ${PACTICIPANT} does not exist in Pactflow"
elif [ $status -ge 400 ]; then
  cat "${output_file}"
  echo "Error deleting branch in Pactflow"
  exit 1
else
  echo "Deleted branch ${GIT_BRANCH} for ${PACTICIPANT} in Pactflow"
fi
