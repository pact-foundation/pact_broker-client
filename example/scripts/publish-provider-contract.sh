# Assumes you've set PACT_BROKER_BASE_URL, PACT_BROKER_USERNAME and PACT_BROKER_PASSWORD already
# Must be executed from root directory of project.

bundle exec bin/pactflow publish-provider-contract $(dirname "$0")/oas.yml \
    --provider pactflow-cli-test-provider \
    --provider-app-version 1.0.0 \
    --branch master \
    --tag master \
    --content-type application/yaml \
    --verification-exit-code=0 \
    --verification-results $(dirname "$0")/oas.yml \
    --verification-results-content-type application/yaml \
    --verifier pactflow-cli-test-provider
