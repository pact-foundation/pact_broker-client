export PACT_BROKER_BASE_URL=${PACT_BROKER_BASE_URL:-"http://localhost:9292"}
bundle exec bin/pactflow publish-provider-contract  \
  script/oas.yml \
  --provider Bar \
  --provider-app-version 1013b5650d61214e19f10558f97fb5a3bb082d44 \
  --branch main \
  --tag dev \
  --specification oas \
  --verification-exit-code 0 \
  --verification-results script/verification-results.txt \
  --verification-results-content-type text/plain \
  --verification-results-format text \
  --verifier my-custom-tool \
  --verifier-version "1.0" \
  --verbose


# bundle exec bin/pactflow publish-provider-contract  \
#   script/oas.yml \
#   --provider Foo \
#   --provider-app-version 1013b5650d61214e19f10558f97fb5a3bb082d44 \
#   --branch main \
#   --tag dev \
#   --specification oas \
#   --content-type application/yml

