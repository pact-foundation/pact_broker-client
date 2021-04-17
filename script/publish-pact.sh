bundle exec bin/pact-broker publish spec/pacts/pact_broker_client-pact_broker.json \
  --consumer-app-version 1.2.7 \
  --broker-base-url http://localhost:9292 \
   --broker-username localhost --broker-password localhost \
    --auto-detect-version-properties \
    --build-url http://mybuild \
    --branch master

