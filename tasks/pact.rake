require 'pact_broker/client/tasks'

PactBroker::Client::PublicationTask.new(:localhost) do | task |
  require 'pact_broker/client/version'
  task.tag = `git rev-parse --abbrev-ref HEAD`.strip
  task.consumer_version = PactBroker::Client::VERSION
  task.pact_broker_base_url = "http://localhost:9292"
end

PactBroker::Client::PublicationTask.new(:remote) do | task |
  require 'pact_broker/client/version'
  task.tag = `git rev-parse --abbrev-ref HEAD`.strip
  task.consumer_version = PactBroker::Client::VERSION
  task.pact_broker_base_url = "https://test.pact.dius.com.au"
  task.pact_broker_basic_auth = {username: ENV.fetch('PACT_BROKER_USERNAME'), password: ENV.fetch('PACT_BROKER_PASSWORD')}
end
