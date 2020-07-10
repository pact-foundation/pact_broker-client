#!/bin/bash

if [ -n "${GITHUB_ACTIONS}" ]; then
  if [ -z "${RUBYGEMS_API_KEY}" ]; then
    echo "RUBYGEMS_API_KEY must be set"
    exit 1
  fi

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
