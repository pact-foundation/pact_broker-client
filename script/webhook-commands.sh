#!/bin/sh

bundle exec bin/pact-broker create-webhook \
  'https://api.github.com/repos/foo/bar/statuses/${pactbroker.consumerVersionNumber}' \
  -X POST \
  -H "Content-Type: application/json" \
  -d '{ "state": "${pactbroker.githubVerificationStatus}", "description": "Pact Verification Tests ${pactbroker.providerVersionTags}", "context": "${pactbroker.providerName}", "target_url": "${pactbroker.verificationResultUrl}" }' \
  --user username:password \
  --description "Publish pact verification status to Github" \
  --contract-published \
  --provider-verification-published \
  --team-uuid 4ac05ed8-9e3b-4159-96c0-ad19e3b93658
