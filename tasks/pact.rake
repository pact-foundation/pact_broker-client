require 'pact_broker/client/tasks'

PactBroker::Client::PublicationTask.new(:localhost) do | task |
  require 'pact_broker/client/version'
  task.tag = `git rev-parse --abbrev-ref HEAD`.strip
  task.consumer_version = PactBroker::Client::VERSION
  task.pact_broker_base_url = "http://localhost:9292"
  task.build_url = "http://ci"
  # task.branch = "main"
end

PactBroker::Client::PublicationTask.new(:remote) do | task |
  require 'pact_broker/client/version'
  task.tag = `git rev-parse --abbrev-ref HEAD`.strip
  task.consumer_version = PactBroker::Client::VERSION
  task.pact_broker_base_url = "https://test.pact.dius.com.au"
  task.pact_broker_basic_auth = {username: ENV.fetch('PACT_BROKER_USERNAME'), password: ENV.fetch('PACT_BROKER_PASSWORD')}
end

PactBroker::Client::PublicationTask.new(:pactflow) do | task |
  version = ENV['GITHUB_SHA']
  tags = ENV['GITHUB_REF'] ? [ENV['GITHUB_REF'].gsub("refs/heads/", "")] : []

  if ENV.fetch('TEST_FEATURE', '') != ''
    version = "#{version}+#{ENV['TEST_FEATURE']}"
    tags = ENV['TEST_FEATURE']
  end

  require 'pact_broker/client/version'
  task.tags = tags
  task.consumer_version = version
  task.pact_broker_base_url = "https://pact-oss.pactflow.io"
  task.pact_broker_token = ENV['PACT_BROKER_TOKEN']
end
