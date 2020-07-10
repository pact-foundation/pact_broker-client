#!/bin/bash

if [ -n "${GITHUB_ACTIONS}" ]; then
  : "${RUBYGEMS_API_KEY:?RUBYGEMS_API_KEY must be set}"
  : "${GITHUB_TOKEN:?GITHUB_TOKEN must be set}"

  echo "Setting up gem credentials..."
  set +x
  mkdir -p ~/.gem

  cat << EOF > ~/.gem/credentials
  ---
  :github: Bearer ${GITHUB_TOKEN}
  :rubygems_api_key: ${RUBYGEMS_API_KEY}
EOF

  chmod 0600 ~/.gem/credentials
  set -x

fi

echo "Running gem release task..."
bundle exec rake release
