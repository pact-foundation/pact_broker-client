require 'pact_broker/client/tasks'

PactBroker::Client::PublishTask.new do | task |
  task.consumer_version = '1'
  task.pattern = FileList['spec/pact/*.json']
  task.hostname = "pact-broker.biq.vpc.realestate.com.au"
  task.scheme = 'http'
end