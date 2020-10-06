# Pact Broker Client

A client for the Pact Broker. Publishes and retrieves pacts, verification results, pacticipants, pacticipant versions and tags. The functionality is available via a CLI, or via Ruby Rake tasks. You can also use the [Pact CLI Docker image](https://hub.docker.com/r/pactfoundation/pact-cli).

[![Build Status](https://travis-ci.org/pact-foundation/pact_broker-client.svg?branch=master)](https://travis-ci.org/pact-foundation/pact_broker-client)

![Trigger update to docs.pact.io](https://github.com/pact-foundation/pact_broker-client/workflows/Trigger%20update%20to%20docs.pact.io/badge.svg)

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
  -k, [--broker-token=BROKER_TOKEN]                        # Pact Broker bearer token
  -t, [--tag=TAG]                                          # Tag name for consumer version. Can be specified multiple times.
  -g, [--tag-with-git-branch], [--no-tag-with-git-branch]  # Tag consumer version with the name of the current git branch. Default: false
  -v, [--verbose], [--no-verbose]                          # Verbose output. Default: false

Publish pacts to a Pact Broker.
```

### create-version-tag

```
Options:
  -a, --pacticipant=PACTICIPANT                            # The pacticipant name
  -e, --version=VERSION                                    # The pacticipant version
  -t, [--tag=TAG]                                          # Tag name for pacticipant version. Can be specified multiple times.
      [--auto-create-version], [--no-auto-create-version]  # Automatically create the pacticipant version if it does not exist. Default: false
  -g, [--tag-with-git-branch], [--no-tag-with-git-branch]  # Tag pacticipant version with the name of the current git branch. Default: false
  -b, --broker-base-url=BROKER_BASE_URL                    # The base URL of the Pact Broker
  -u, [--broker-username=BROKER_USERNAME]                  # Pact Broker basic auth username
  -p, [--broker-password=BROKER_PASSWORD]                  # Pact Broker basic auth password
  -k, [--broker-token=BROKER_TOKEN]                        # Pact Broker bearer token
  -v, [--verbose], [--no-verbose]                          # Verbose output. Default: false

Add a tag to a pacticipant version
```

### can-i-deploy

You will need >= v2.13.0 of the Pact Broker for this feature to work. See the [Can I Deploy](https://docs.pact.io/pact_broker/can_i_deploy) page in the Pact docs for an explanation of how `can-i-deploy` works under the hood.

```
Usage:
  pact-broker can-i-deploy -a, --pacticipant=PACTICIPANT -b, --broker-base-url=BROKER_BASE_URL

Options:
  -a, --pacticipant=PACTICIPANT            # The pacticipant name. Use once for each pacticipant being checked.
  -e, [--version=VERSION]                  # The pacticipant version. Must be entered after the --pacticipant that it relates to.
  -l, [--latest=[TAG]]                     # Use the latest pacticipant version. Optionally specify a TAG to use the latest version with the specified tag.
      [--to=TAG]                           # This is too hard to explain in a short sentence. Look at the examples.
  -b, --broker-base-url=BROKER_BASE_URL    # The base URL of the Pact Broker
  -u, [--broker-username=BROKER_USERNAME]  # Pact Broker basic auth username
  -p, [--broker-password=BROKER_PASSWORD]  # Pact Broker basic auth password
  -k, [--broker-token=BROKER_TOKEN]        # Pact Broker bearer token
  -o, [--output=OUTPUT]                    # json or table
                                           # Default: table
  -v, [--verbose], [--no-verbose]          # Verbose output. Default: false
      [--retry-while-unknown=TIMES]        # The number of times to retry while there is an unknown verification result (ie. the provider verification is likely still running)
                                           # Default: 0
      [--retry-interval=SECONDS]           # The time between retries in seconds. Use in conjuction with --retry-while-unknown
                                           # Default: 10

Description:
  Returns exit code 0 or 1, indicating whether or not the specified pacticipant versions are compatible. Prints out the relevant
  pact/verification details.

  The environment variables PACT_BROKER_BASE_URL, PACT_BROKER_BASE_URL_USERNAME and PACT_BROKER_BASE_URL_PASSWORD may be used
  instead of their respective command line options.
```

Returns exit code 0 or 1, indicating whether or not the specified application (pacticipant) versions are compatible (ie. safe to deploy). Prints out the relevant pact/verification details, indicating any missing or failed verification results.

The environment variables PACT_BROKER_BASE_URL, PACT_BROKER_USERNAME and PACT_BROKER_PASSWORD may be used instead of their respective command line options.

There are two ways to use `can-i-deploy`. The first (recommended and most commonly used) approach is to specify just the application version you want to deploy and let the Pact Broker work out the dependencies for you. The second approach is to specify each application version explicitly. This would generally only be used if there were limitations that stopped you being able to use the first approach.

#### Specifying an application version

To specify an application (pacticipant) version you need to provide:

* the name of the application using the `--pacticipant PACTICIPANT` parameter,
* directly followed by *one* of the following parameters:
    * `--version VERSION` to specify a known application version (recommended)
    * `--latest` to specify the latest version
    * `--latest TAG` to specify the latest version that has a particular tag
    * `--all TAG` to specify all the versions that have a particular tag (eg. "all prod" versions). This would be used when ensuring you have backwards compatiblity with all production mobile clients for a provider. Note, when using this option, you need to specify dependency explicitly (see the second usage option).

Using a specific version is the easiest way to ensure you get an accurate response that won't be affected by race conditions.

#### Recommended usage - allowing the Pact Broker to automatically determine the dependencies

If you would like the Pact Broker to calculate the dependencies for you when you want to deploy an application into a given environment, you will need to let the Broker know which version of each application is in that environment. To do this, the relevant application version resource in the Broker will need to be "tagged" with the name of the environment during the deployment process:

    $ pact-broker create-version-tag --pacticipant Foo --version 173153ae0 --tag test

This allows you to use the following simple command to find out if you are safe to deploy:

    $ pact-broker can-i-deploy --pacticipant PACTICIPANT --version VERSION \
                               --to ENVIRONMENT \
                               --broker-base-url BROKER_BASE_URL

If the `--to` tag is omitted, then the query will return the compatiblity with the overall latest version of each of the other applications.

Examples:


Can I deploy version 173153ae0 of application Foo to the test environment?


    $ pact-broker can-i-deploy --pacticipant Foo --version 173153ae0 \
                               --to test \
                               --broker-base-url https://my-pact-broker


Can I deploy the latest version of application Foo with the latest version of each of the applications it integrates to?


    $ pact-broker can-i-deploy --pacticipant Foo --latest \
                               --broker-base-url https://my-pact-broker


Can I deploy the latest version of the application Foo that has the tag "test" to the "prod" environment?

    $ pact-broker can-i-deploy --pacticipant Foo --latest test \
                               --to prod \
                               --broker-base-url https://my-pact-broker



#### Alternate usage - specifying dependencies explicitly

If you are unable to use tags, or there is some other limitation that stops you from using the recommended approach, you can specify one or more of the dependencies explictly. You must also do this if you want to use the `--all TAG` option for any of the pacticipants.

You can specify as many application versions as you like, and you can even specify multiple versions of the same application (repeat the `--pacticipant` name and supply a different version). If you have a monorepo and you deploy a group of applications together, you can either call `can-i-deploy` once for each application, or you can group them all together by specifying a `--pacticipant` and `--version` for each sub-application.

You can use explictly declared dependencies with or without the `--to ENVIRONMENT`. For example, if you declare two (or more) application versions with no `--to ENVIRONMENT`, then only the applications you specify will be taken into account when determining if it is safe to deploy. If you declare two (or more) application versions _as well as_ a `--to ENVIRONMENT`, then the Pact Broker will work out what integrations your declared applications will have in that environment when determining if it safe to deploy. When using this script for a production release, and you are using tags, it is always the most future-proof option to use the `--to` if possible, as it will catch any newly added consumers or providers.

If you are finding that your dependencies are not being automatically included when you supply multiple pacticipant versions, please upgrade to the latest version of the Pact Broker, as this is a more recently added feature.


    $ pact-broker can-i-deploy --pacticipant PACTICIPANT_1 [--version VERSION_1 | --latest [TAG_1] | --all TAG_1] \
                               --pacticipant PACTICIPANT_2 [--version VERSION_2 | --latest [TAG_2] | --all TAG_2] \
                               [--to ENVIRONMENT] \
                               --broker-base-url BROKER_BASE_URL

Examples:


Can I deploy version Foo version 173153ae0 and Bar version ac23df1e8 together?


    $ pact-broker can-i-deploy --pacticipant Foo --version 173153ae0 \
                               --pacticipant Bar --version ac23df1e8 \
                               --broker-base-url BROKER_BASE_URL


Can I deploy the latest version of Foo with tag "master" and the latest version of Bar with tag "master" together?

    $ pact-broker can-i-deploy --pacticipant Foo --latest master \
                               --pacticipant Bar --latest master \
                               --broker-base-url BROKER_BASE_URL

Can I deploy all the applications in my monorepo to prod?

    $ pact-broker can-i-deploy --pacticipant A --version a7e28207 \
                               --pacticipant B --version a7e28207 \
                               --pacticipant C --version a7e28207 \
                               --to prod \
                               --broker-base-url BROKER_BASE_URL                               

Mobile provider use case - can I deploy version b80e7b1b of Bar, all versions of Foo with tag "prod", and the latest version tagged "prod" of any other automatically calculated dependencies together? (Eg. where Bar is a provider and Foo is a mobile consumer with multiple versions in production, and Bar also has its own providers it needs to be compatible with.)


    $ pact-broker can-i-deploy --pacticipant Bar --version b80e7b1b \
                               --pacticipant Foo --all prod \
                               --to prod \
                               --broker-base-url BROKER_BASE_URL

### create-webhook

```
Usage:
  pact-broker create-webhook URL -X, --request=METHOD -b, --broker-base-url=BROKER_BASE_URL

Options:
  -X, --request=METHOD
            # HTTP method
  -H, [--header=one two three]
            # Header
  -d, [--data=DATA]
            # Data
  -u, [--user=USER]
            # Basic auth username and password eg. username:password
      [--consumer=CONSUMER]
            # Consumer name
      [--provider=PROVIDER]
            # Provider name
  -b, --broker-base-url=BROKER_BASE_URL
            # The base URL of the Pact Broker
      [--broker-username=BROKER_USERNAME]
            # Pact Broker basic auth username
  -p, [--broker-password=BROKER_PASSWORD]
            # Pact Broker basic auth password
  -k, [--broker-token=BROKER_TOKEN]
            # Pact Broker bearer token
      [--description=DESCRIPTION]
            # The description of the webhook
      [--contract-content-changed], [--no-contract-content-changed]
            # Trigger this webhook when the pact content changes
      [--contract-published], [--no-contract-published]
            # Trigger this webhook when a pact is published
      [--provider-verification-published], [--no-provider-verification-published]
            # Trigger this webhook when a provider verification result is published
      [--provider-verification-failed], [--no-provider-verification-failed]
            # Trigger this webhook when a failed provider verification result is published
      [--provider-verification-succeeded], [--no-provider-verification-succeeded]
            # Trigger this webhook when a successful provider verification result is published
  -v, [--verbose], [--no-verbose]
            # Verbose output. Default: false

Description:
  Create a curl command that executes the request that you want your webhook to execute, then replace "curl" with "pact-broker
  create-webhook" and add the consumer, provider, event types and broker details. Note that the URL must be the first parameter
  when executing create-webhook.
```

### create-or-update-webhook

```
Usage:
  pact-broker create-or-update-webhook URL --uuid=UUID -X, --request=METHOD -b, --broker-base-url=BROKER_BASE_URL

Options:
  -X, --request=METHOD
            # HTTP method
  -H, [--header=one two three]
            # Header
  -d, [--data=DATA]
            # Data
  -u, [--user=USER]
            # Basic auth username and password eg. username:password
      [--consumer=CONSUMER]
            # Consumer name
      [--provider=PROVIDER]
            # Provider name
  -b, --broker-base-url=BROKER_BASE_URL
            # The base URL of the Pact Broker
      [--broker-username=BROKER_USERNAME]
            # Pact Broker basic auth username
  -p, [--broker-password=BROKER_PASSWORD]
            # Pact Broker basic auth password
  -k, [--broker-token=BROKER_TOKEN]
            # Pact Broker bearer token
      [--description=DESCRIPTION]
            # The description of the webhook
      [--contract-content-changed], [--no-contract-content-changed]
            # Trigger this webhook when the pact content changes
      [--contract-published], [--no-contract-published]
            # Trigger this webhook when a pact is published
      [--provider-verification-published], [--no-provider-verification-published]
            # Trigger this webhook when a provider verification result is published
      [--provider-verification-failed], [--no-provider-verification-failed]
            # Trigger this webhook when a failed provider verification result is published
      [--provider-verification-succeeded], [--no-provider-verification-succeeded]
            # Trigger this webhook when a successful provider verification result is published
  -v, [--verbose], [--no-verbose]
            # Verbose output. Default: false
      --uuid=UUID
            # Specify the uuid for the webhook

Description:
  Create a curl command that executes the request that you want your webhook to execute, then replace "curl" with "pact-broker
  create-or-update-webhook" and add the consumer, provider, event types and broker details. Note that the URL must be the first
  parameter when executing create-or-update-webhook and a uuid must also be provided. You can generate a valid UUID by using
  the `generate-uuid` command.
```

### describe-version

```
Usage:
  pact-broker describe-version -a, --pacticipant=PACTICIPANT -b, --broker-base-url=BROKER_BASE_URL

Options:
  -a, --pacticipant=PACTICIPANT            # The name of the pacticipant that the version belongs to.
  -e, [--version=VERSION]                  # The pacticipant version number.
  -l, [--latest=[TAG]]                     # Describe the latest pacticipant version. Optionally specify a TAG to describe the latest version with the specified tag.
  -b, --broker-base-url=BROKER_BASE_URL    # The base URL of the Pact Broker
  -u, [--broker-username=BROKER_USERNAME]  # Pact Broker basic auth username
  -p, [--broker-password=BROKER_PASSWORD]  # Pact Broker basic auth password
  -k, [--broker-token=BROKER_TOKEN]        # Pact Broker bearer token
  -o, [--output=OUTPUT]                    # json or table or id
                                           # Default: table
  -v, [--verbose], [--no-verbose]          # Verbose output. Default: false

Describes a pacticipant version. If no version or tag is specified, the latest version is described.
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
  task.pact_broker_token = "1234abcd" # Bearer token
  task.write_method = :merge # optional, this will merge the published pact into an existing pact rather than overwriting it if one exists. Not recommended, as it makes a mulch of the workflow on the broker.
end
```

```bash
# In CI script

bundle exec rake pact:publish
```

[pact-ruby-standalone]: https://github.com/pact-foundation/pact-ruby-standalone/releases
[docker]: https://hub.docker.com/r/pactfoundation/pact-cli
