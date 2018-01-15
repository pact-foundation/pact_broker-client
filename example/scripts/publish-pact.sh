# assumes you've set PACT_BROKER_BASE_URL, PACT_BROKER_USERNAME and PACT_BROKER_PASSWORD already

bundle exec bin/pact-broker publish $(dirname "$0")/pact.json --consumer-app-version=1.0.0 --tag master
