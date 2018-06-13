# Pact Broker Client

A client for the Pact Broker. Publishes pacts to, and retrieves pacts from, the pact broker. The functionality is available via a CLI, or via Ruby Rake tasks.

[![Build Status](https://travis-ci.org/pact-foundation/pact_broker-client.svg?branch=master)](https://travis-ci.org/pact-foundation/pact_broker-client)

## Installation

### CLI

Download the latest [pact-ruby-standalone][pact-ruby-standalone] package. You do not need Ruby to run the CLI, as the Ruby runtime is packaged with the executable using Travelling Ruby.

### Ruby

Add `gem 'pact_broker-client'` to your Gemfile and run `bundle install`, or install the gem directly by running `gem install pact_broker-client`.

## Usage - CLI

To connect to a Pact Broker that uses custom SSL cerificates, set the environment variable `$SSL_CERT_FILE` or `$SSL_CERT_DIR` to a path that contains the appropriate certificate.

### publish

```
Usage:
  pact-broker publish PACT_DIRS_OR_FILES ... -a, --consumer-app-version=CONSUMER_APP_VERSION -b, --broker-base-url=BROKER_BASE_URL

Options:
  -a, --consumer-app-version=CONSUMER_APP_VERSION          # The consumer application version
  -b, --broker-base-url=BROKER_BASE_URL                    # The base URL of the Pact Broker
  -u, [--broker-username=BROKER_USERNAME]                  # Pact Broker basic auth username
  -p, [--broker-password=BROKER_PASSWORD]                  # Pact Broker basic auth password
  -t, [--tag=TAG]                                          # Tag name for consumer version. Can be specified multiple times.
  -g, [--tag-with-git-branch], [--no-tag-with-git-branch]  # Tag consumer version with the name of the current git branch. Default: false
  -v, [--verbose], [--no-verbose]                          # Verbose output. Default: false

Publish pacts to a Pact Broker.
```

### create-version-tag

```
Usage:
  pact-broker create-version-tag -a, --pacticipant=PACTICIPANT -b, --broker-base-url=BROKER_BASE_URL -e, --version=VERSION

Options:
  -a, --pacticipant=PACTICIPANT                            # The pacticipant name
  -e, --version=VERSION                                    # The pacticipant version
  -t, [--tag=TAG]                                          # Tag name for pacticipant version. Can be specified multiple times.
  -g, [--tag-with-git-branch], [--no-tag-with-git-branch]  # Tag pacticipant version with the name of the current git branch. Default: false
  -b, --broker-base-url=BROKER_BASE_URL                    # The base URL of the Pact Broker
  -u, [--broker-username=BROKER_USERNAME]                  # Pact Broker basic auth username
  -p, [--broker-password=BROKER_PASSWORD]                  # Pact Broker basic auth password
  -v, [--verbose], [--no-verbose]                          # Verbose output. Default: false

Add a tag to a pacticipant version
```

### can-i-deploy

You will need >= v2.13.0 of the Pact Broker for this feature to work.

```
Usage:
  pact-broker can-i-deploy -a, --pacticipant=PACTICIPANT -b, --broker-base-url=BROKER_BASE_URL

Options:
  -a, --pacticipant=PACTICIPANT            # The pacticipant name. Use once for each pacticipant being checked.
  -e, [--version=VERSION]                  # The pacticipant version. Must be entered after the --pacticipant that it relates to.
  -l, [--latest=[TAG]]                     # Use the latest pacticipant version. Optionally specify a TAG to use the latest version with the specified tag.
  -b, --broker-base-url=BROKER_BASE_URL    # The base URL of the Pact Broker
  -u, [--broker-username=BROKER_USERNAME]  # Pact Broker basic auth username
  -p, [--broker-password=BROKER_PASSWORD]  # Pact Broker basic auth password
  -o, [--output=OUTPUT]                    # json or table
                                           # Default: table
  -v, [--verbose], [--no-verbose]          # Verbose output. Default: false

Description:
  Returns exit code 0 or 1, indicating whether or not the specified pacticipant versions are compatible. Prints out the relevant pact/verification details.

  The environment variables PACT_BROKER_BASE_URL, PACT_BROKER_BASE_URL_USERNAME and PACT_BROKER_BASE_URL_PASSWORD may be used instead of their respective command line options.

  SCENARIOS

  # If every build goes straight to production

  Check the status of the pacts for a pacticipant version. Note that this only checks that the most recent verification for each pact is successful. It doesn't provide any assurance that the pact has been verified by the *production* version of the provider, however, it is sufficient if you are doing true continuous deployment.

    $ pact-broker can-i-deploy --pacticipant PACTICIPANT --version VERSION --broker-base-url BROKER_BASE_URL

  # If every build does NOT go straight to production

  ## Recommended approach

  If all applications within the pact network are not being deployed continuously (ie. if there is a gap between pact verification and actual deployment) then the following strategy is recommended. Each application version should be tagged in the broker with the name of the stage (eg. test, staging, production) as it is deployed (see the pact-broker create-version-tag CLI). This enables you to use the following very simple command to check if the application version you are about to deploy is compatible with every other application version already deployed in that environment.

    $ pact-broker can-i-deploy --pacticipant PACTICIPANT --version VERSION --to TAG --broker-base-url BROKER_BASE_URL

  ## Other approaches

  If you do not/cannot tag every application at deployment, you have two options. You can either use the very first form of this command which just checks that the *latest* verification is successful (not recommended as it's the production version that you really care about) or you will need to determine the production versions of each collaborating application from some other source (eg. git) and explictly reference each one using one using the format `--pacticipant PACTICIPANT1 --version VERSION1 --pacticipant PACTICIPANT2 --version VERSION2 ...`

  # Other commands

  Check the status of the pacts for the latest pacticipant version. This form is not recommended for use in your CI as it is possible that the version you are about to deploy is not the the version that the Broker considers the latest. It's best to specify the version explictly.

    $ pact-broker can-i-deploy --pacticipant PACTICIPANT --latest --broker-base-url BROKER_BASE_URL

  Check the status of the pacts for the latest pacticipant version for a given tag:

    $ pact-broker can-i-deploy --pacticipant PACTICIPANT --latest TAG --broker-base-url BROKER_BASE_URL

  Check the status of the pacts between two (or more) specific pacticipant versions:

    $ pact-broker can-i-deploy --pacticipant PACTICIPANT1 --version VERSION1 --pacticipant PACTICIPANT2 --version VERSION2 --broker-base-url BROKER_BASE_URL

  Check the status of the pacts between the latest versions of two (or more) pacticipants:

    $ pact-broker can-i-deploy --pacticipant PACTICIPANT1 --latest --pacticipant PACTICIPANT2 --latest --broker-base-url BROKER_BASE_URL

  Check the status of the pacts between the latest versions of two (or more) pacticipants with a given tag:

  $ pact-broker can-i-deploy --pacticipant PACTICIPANT1 --latest TAG1 --pacticipant PACTICIPANT2 --latest TAG2 --broker-base-url BROKER_BASE_URL

```

### create-webhook

```
Usage:
  pact-broker create-webhook URL --consumer=CONSUMER --provider=PROVIDER -X, --request=REQUEST -b, --broker-base-url=BROKER_BASE_URL

Options:
  -X, --request=REQUEST                                                            # HTTP method
  -H, [--header=one two three]                                                     # Header
  -d, [--data=DATA]                                                                # Data
  -u, [--user=USER]                                                                # Basic auth username and password eg. username:password
      --consumer=CONSUMER                                                          # Consumer name
      --provider=PROVIDER                                                          # Provider name
  -b, --broker-base-url=BROKER_BASE_URL                                            # The base URL of the Pact Broker
  -u, [--broker-username=BROKER_USERNAME]                                          # Pact Broker basic auth username
  -p, [--broker-password=BROKER_PASSWORD]                                          # Pact Broker basic auth password
      [--contract-content-changed], [--no-contract-content-changed]                # Trigger this webhook when the pact content changes
      [--provider-verification-published], [--no-provider-verification-published]  # Trigger this webhook when a provider verification result is published
  -v, [--verbose], [--no-verbose]                                                  # Verbose output. Default: false

Description:
  Create a curl command that executes the request that you want your webhook to execute, then replace "curl" with "pact-broker
  create-webhook" and add the consumer, provider, event types and broker details. Note that the URL must be the first parameter
  when executing create-webhook.
```

## Usage - Ruby

### Consumer

```ruby
# In Gemfile

gem "pact_broker-client"
```

```ruby
# In Rakefile

require 'pact_broker/client/tasks'

PactBroker::Client::PublicationTask.new do | task |
  require 'my_consumer/version'
  task.consumer_version = MyConsumer::VERSION
  task.pattern = 'custom/path/to/pacts/*.json' # optional, default value is 'spec/pacts/*.json'
  task.pact_broker_base_url = "http://pact-broker"
  task.tag_with_git_branch = true|false # Optional but STRONGLY RECOMMENDED as it will greatly assist with your pact workflow. Result will be merged with other specified task.tags
  task.tags = ["dev"] # optional
  task.pact_broker_basic_auth =  { username: 'basic_auth_user', password: 'basic_auth_pass'} # optional
  task.write_method = :merge # optional, this will merge the published pact into an existing pact rather than overwriting it if one exists. Not recommended, as it makes a mulch of the workflow on the broker.
end
```

```bash
# In CI script

bundle exec rake pact:publish
```

[wiki-tags]: https://github.com/pact-foundation/pact_broker/wiki/Using-tags
[pact-ruby-standalone]: https://github.com/pact-foundation/pact-ruby-standalone/releases
