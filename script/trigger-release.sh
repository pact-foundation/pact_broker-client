#!/bin/bash

output=$(curl -v -X POST https://api.github.com/repos/pact-foundation/pact_broker-client/dispatches \
      -H 'Accept: application/vnd.github.everest-preview+json' \
      -H "Authorization: Bearer $GITHUB_ACCESS_TOKEN" \
      -d '{"event_type": "release-patch"}' 2>&1)

if  ! echo "${output}" | grep "HTTP\/1.1 204" > /dev/null; then
  echo "$output" | sed  "s/${GITHUB_ACCESS_TOKEN}/****/g"
  echo "Failed to do the thing"
  exit 1
fi

echo "See https://github.com/pact-foundation/pact_broker-client/actions?query=workflow%3A%22Release+gem%22"
