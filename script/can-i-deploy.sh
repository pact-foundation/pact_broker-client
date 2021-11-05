bundle exec bin/pact-broker publish spec/pacts/pact_broker_client-pact_broker.json \
  --consumer-app-version 1.2.26 \
  --branch main

bundle exec bin/pact-broker can-i-deploy --pacticipant "Pact Broker Client" --branch "main"
