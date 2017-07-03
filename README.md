# Pact Broker Client

A client for the Pact Broker. Publishes pacts to, and retrieves pacts from, the pact broker.

[![Build Status](https://travis-ci.org/pact-foundation/pact_broker-client.svg?branch=master)](https://travis-ci.org/pact-foundation/pact_broker-client)

## Usage

You will need an instance of a [Pact Broker](https://github.com/bethesque/pact_broker). It's URL will be used below in the configuration for the Consumer and the Provider. eg. http://pact-broker.my.org

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
  task.pact_broker_base_url = "http://pact-broker.my.org"
  task.tag = "dev" # optional
  task.pact_broker_basic_auth =  { username: 'basic_auth_user', password: 'basic_auth_pass'} #optional
  task.write_method = :merge # optional, this will merge the published pact into an existing pact rather than overwriting it if one exists. Not recommended, as it makes a mulch of the workflow on the broker.
end
```

If you want to use the git branch name as the tag name, use:

```ruby
  task.tag = `git rev-parse --abbrev-ref HEAD`.strip
```

```bash
# In CI script

rake pact:publish
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
