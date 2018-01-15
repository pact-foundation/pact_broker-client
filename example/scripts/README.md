# Example scripts

These are designed to be run from the top level of the pact_broker-client repository.

You will need to set your own values for `PACT_BROKER_BASE_URL`, `PACT_BROKER_USERNAME`, and `PACT_BROKER_PASSWORD`

eg.

    export PACT_BROKER_BASE_URL="http://..."
    export PACT_BROKER_USERNAME="username"
    export PACT_BROKER_PASSWORD="password"
    example/scripts/publish-pact.sh
    example/scripts/publish-verification.sh
