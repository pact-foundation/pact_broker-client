response_body=$(curl -u ${PACT_BROKER_USERNAME}:${PACT_BROKER_PASSWORD} ${PACT_BROKER_BASE_URL}/pacts/provider/Animal%20Service/consumer/Zoo%20App/latest)
verification_url=$(echo "${response_body}" | ruby -e "require 'json'; puts JSON.parse(ARGF.read)['_links']['pb:publish-verification-results']['href']")
curl -XPOST -u ${PACT_BROKER_USERNAME}:${PACT_BROKER_PASSWORD} -H 'Content-Type: application/json' -d@$(dirname "$0")/verification.json ${verification_url}
