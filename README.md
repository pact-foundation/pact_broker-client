# Pact Broker Client

A client for the Pact Broker. Publishes pacts to, and retrieves pacts from, the pact broker. The functionality is available via a CLI, or via Ruby Rake tasks.

[![Build Status](https://travis-ci.org/pact-foundation/pact_broker-client.svg?branch=master)](https://travis-ci.org/pact-foundation/pact_broker-client)

## Installation

### CLI

Download the latest [pact-ruby-standalone][pact-ruby-standalone] package. You do not need Ruby to run the CLI, as the Ruby runtime is packaged with the executable using Travelling Ruby.

### Ruby

Add `gem 'pact_broker-client'` to your Gemfile and run `bundle install`, or install the gem directly by running `gem install pact_broker-client`.

## Usage - CLI

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

*This feature is in beta release, and backwards compatibility is NOT guaranteed.*
You will need the latest version of the Pact Broker for this feature to work.

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
  Returns exit code 0 or 1, indicating whether or not the specified pacticipant versions are compatible. Prints out the
  relevant pact/verification details.

  The environment variables PACT_BROKER_BASE_URL, PACT_BROKER_USERNAME and PACT_BROKER_PASSWORD may be used instead of
  their respective command line options.

  SCENARIOS

  Check the status of the pacts for a pacticipant version:

  $ pact-broker can-i-deploy --pacticipant PACTICIPANT --version VERSION --broker-base-url BROKER_BASE_URL

  Check the status of the pacts for the latest pacticipant version:

  $ pact-broker can-i-deploy --pacticipant PACTICIPANT --latest --broker-base-url BROKER_BASE_URL

  Check the status of the pacts for the latest pacticipant version for a given tag:

  $ pact-broker can-i-deploy --pacticipant PACTICIPANT --latest TAG --broker-base-url BROKER_BASE_URL

  Check the status of the pacts between two (or more) specific pacticipant versions:

  $ pact-broker can-i-deploy --pacticipant PACTICIPANT1 --version VERSION1 --pacticipant PACTICIPANT2 --version VERSION2
  --broker-base-url BROKER_BASE_URL

  Check the status of the pacts between the latest versions of two (or more) pacticipants:

  $ pact-broker can-i-deploy --pacticipant PACTICIPANT1 --latest --pacticipant PACTICIPANT2 --latest --broker-base-url
  BROKER

  Check the status of the pacts between the latest versions of two (or more) pacticipants with a given tag:

  $ pact-broker can-i-deploy --pacticipant PACTICIPANT1 --latest TAG1 --pacticipant PACTICIPANT2 --latest TAG2
  --broker-base-url BROKER_BASE_URL
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
  task.tag_with_git_branch = true|false # STRONGLY RECOMMENDED as it will greatly assist with your pact workflow. Optional, will merge result with other specified task.tags
  task.tags = ["dev"] # optional
  task.pact_broker_basic_auth =  { username: 'basic_auth_user', password: 'basic_auth_pass'} # optional
  task.write_method = :merge # optional, this will merge the published pact into an existing pact rather than overwriting it if one exists. Not recommended, as it makes a mulch of the workflow on the broker.
end
```

```bash
# In CI script

bundle exec rake pact:publish
```

### Provider

```ruby
# In spec/service_consumers/pact_helper.rb

require 'pact/provider/rspec'

Pact.service_provider "My Provider" do

  honours_pact_with "My Consumer" do
    pact_uri URI.encode("http://pact-broker.my.org/pact/provider/My Provider/consumer/My Consumer/latest")
  end

end
```



[wiki-tags]: https://github.com/pact-foundation/pact_broker/wiki/Using-tags
[pact-ruby-standalone]: https://github.com/pact-foundation/pact-ruby-standalone/releases
