bundle exec bin/pact-broker publish "pact_broker-client/spec/pacts/Pact Broker Client-Pact Broker.json" \
  --consumer-app-version 1.2.26 \
  --branch main

bundle exec bin/pact-broker can-i-deploy --pacticipant "Pact Broker Client" --branch "main"
