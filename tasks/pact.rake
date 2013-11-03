require 'pact_broker/client/tasks'

PactBroker::Client::PublicationTask.new do | task |
  require 'pact_broker/client/version'
  task.consumer_version = PactBroker::Client::VERSION
  task.pact_broker_base_url = "http://localhost:9292"
end