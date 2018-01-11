version="1"
stage="development"
application="A"

export PACT_BROKER_CLIENT="bundle exec bin/pact-broker"
export PACT_BROKER_BASE_URL="http://localhost:9292"

can_i_deploy_output=$(${PACT_BROKER_CLIENT} can-i-deploy --pacticipant ${application} --version ${version})
can_i_deploy_exit_code=$?

set -e

echo "${can_i_deploy_output}"

if [[ "${can_i_deploy_exit_code}" == "0" ]]; then
  existing_tags=$(${PACT_BROKER_CLIENT} describe-version --pacticipant ${application} --version ${version} --output json | jq "[._embedded.tags[].name]" | jq 'join("\n")' --raw-output)
  if [ $(echo "${existing_tags}" | grep "${stage}") ]; then
    echo "Version ${version} of ${application} has already been deployed to ${stage}"
  else
    echo "Deploying version ${version} of ${application} to ${stage}"
    # do deployment here
    ${PACT_BROKER_CLIENT} create-version-tag --pacticipant ${application} --version ${version} --tag ${stage}
  fi
else
  echo "Cannot currently deploy version ${version} of ${application} to ${stage}"
fi
