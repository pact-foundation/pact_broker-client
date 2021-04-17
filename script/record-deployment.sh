PACT_BROKER_FEATURES=deployments bundle exec bin/pact-broker record-deployment \
   --pacticipant foo-consumer --version 1 --environment prod --broker-base-url http://localhost:9292 --no-replaced_previous_deployed_version


