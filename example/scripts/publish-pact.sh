# assumes you've set PACT_BROKER_BASE_URL, PACT_BROKER_USERNAME and PACT_BROKER_PASSWORD already
# Must be executed from root directory of project.

bundle exec bin/pact-broker publish $(dirname "$0")/pact.json
bundle exec bin/pact-broker publish $(dirname "$0")/pact.json --auto-detect-version-properties
bundle exec bin/pact-broker publish $(dirname "$0")/pact.json --auto-detect-version-properties --tag-with-git-branch
bundle exec bin/pact-broker publish $(dirname "$0")/pact.json --branch branch-user-override
bundle exec bin/pact-broker publish $(dirname "$0")/pact.json --branch branch-user-override --auto-detect-version-properties
bundle exec bin/pact-broker publish $(dirname "$0")/pact.json --branch branch-user-override --auto-detect-version-properties --tag-with-git-branch
bundle exec bin/pact-broker publish $(dirname "$0")/pact.json --consumer-app-version commit-user-override
bundle exec bin/pact-broker publish $(dirname "$0")/pact.json --consumer-app-version commit-user-override --branch branch-user-override
bundle exec bin/pact-broker publish $(dirname "$0")/pact.json --consumer-app-version commit-user-override --auto-detect-version-properties
bundle exec bin/pact-broker publish $(dirname "$0")/pact.json --consumer-app-version commit-user-override --auto-detect-version-properties --tag-with-git-branch
bundle exec bin/pact-broker publish $(dirname "$0")/pact.json --consumer-app-version commit-user-override --branch branch-user-override --auto-detect-version-properties
bundle exec bin/pact-broker publish $(dirname "$0")/pact.json --consumer-app-version commit-user-override --branch branch-user-override --auto-detect-version-properties --tag-with-git-branch

bundle exec bin/pact-broker publish $(dirname "$0")/pact.json -r
bundle exec bin/pact-broker publish $(dirname "$0")/pact.json -r -g
bundle exec bin/pact-broker publish $(dirname "$0")/pact.json -h branch-user-override
bundle exec bin/pact-broker publish $(dirname "$0")/pact.json -h branch-user-override -r
bundle exec bin/pact-broker publish $(dirname "$0")/pact.json -h branch-user-override -r -g
bundle exec bin/pact-broker publish $(dirname "$0")/pact.json -a commit-user-override
bundle exec bin/pact-broker publish $(dirname "$0")/pact.json -a commit-user-override -r
bundle exec bin/pact-broker publish $(dirname "$0")/pact.json -a commit-user-override -r -g
bundle exec bin/pact-broker publish $(dirname "$0")/pact.json -a commit-user-override -h branch-user-override
bundle exec bin/pact-broker publish $(dirname "$0")/pact.json -a commit-user-override -h branch-user-override -r
bundle exec bin/pact-broker publish $(dirname "$0")/pact.json -a commit-user-override -h branch-user-override -r -g
