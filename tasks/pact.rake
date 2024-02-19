require "pact_broker/client/tasks"
require "pact_broker/client/git"

PactBroker::Client::PublicationTask.new(:localhost) do | task |
  require "pact_broker/client/version"
  task.tag = `git rev-parse --abbrev-ref HEAD`.strip
  task.consumer_version = PactBroker::Client::VERSION
  task.pact_broker_base_url = "http://localhost:9292"
  task.build_url = "http://ci"
  # task.branch = "main"
end

PactBroker::Client::PublicationTask.new(:remote) do | task |
  require "pact_broker/client/version"
  task.tag = `git rev-parse --abbrev-ref HEAD`.strip
  task.consumer_version = PactBroker::Client::VERSION
  task.pact_broker_base_url = "https://test.pact.dius.com.au"
  task.pact_broker_basic_auth = { username: ENV.fetch("PACT_BROKER_USERNAME"), password: ENV.fetch("PACT_BROKER_PASSWORD") }
end


PactBroker::Client::PublicationTask.new(:pactflow_pact_foundation) do | task |
  version = ENV.fetch("GITHUB_SHA")
  branch = ENV.fetch("GITHUB_REF").gsub("refs/heads/", "")
  feature = ENV.fetch("TEST_FEATURE", "")
  tag = branch

  if feature != ""
    version = "#{version}+#{feature}"
    tag = "#{tag}+#{feature}"
  end

  require "pact_broker/client/version"
  task.auto_detect_version_properties = false
  task.tags = [tag]
  task.branch = branch
  task.consumer_version = version
  task.pact_broker_base_url = "https://pact-foundation.pactflow.io"
  task.pact_broker_token = ENV["PACT_BROKER_TOKEN_PACT_FOUNDATION"]
  task.build_url = PactBroker::Client::Git.build_url
end
PactBroker::Client::PublicationTask.new(:pactflow_auto_on_nil_commit_nil_branch) do | task |
  require 'pact_broker/client/version'
  # publish with auto detected commit and branch
  task.auto_detect_version_properties = true
  task.branch = nil
  task.consumer_version = nil
  task.pact_broker_base_url = ENV['PACT_BROKER_BASE_URL']
  task.pact_broker_token = ENV['PACT_BROKER_TOKEN']
  task.build_url = PactBroker::Client::Git.build_url
end
PactBroker::Client::PublicationTask.new(:pactflow_auto_on_user_commit_user_branch) do | task |
  require 'pact_broker/client/version'
  # always accept user provided commit and branch
  # even when auto_detect_version_properties enabled
  task.auto_detect_version_properties = true
  task.branch = 'user-provided-branch'
  task.consumer_version = 'user-provided-version'
  task.pact_broker_base_url = ENV['PACT_BROKER_BASE_URL']
  task.pact_broker_token = ENV['PACT_BROKER_TOKEN']
  task.build_url = PactBroker::Client::Git.build_url
end

PactBroker::Client::PublicationTask.new(:pactflow_auto_on_user_commit_nil_branch) do | task |
  require 'pact_broker/client/version'
  # auto detect branch, always accept user provided commit
  # even where set to auto_detect_version_properties
  task.auto_detect_version_properties = true
  task.branch = nil
  task.consumer_version = 'user-provided-version'
  task.pact_broker_base_url = ENV['PACT_BROKER_BASE_URL']
  task.pact_broker_token = ENV['PACT_BROKER_TOKEN']
  task.build_url = PactBroker::Client::Git.build_url
end
PactBroker::Client::PublicationTask.new(:pactflow_auto_on_nil_commit_user_branch) do | task |
  require 'pact_broker/client/version'
  # auto detect commit, always accept user provided branch
  # even where set to auto_detect_version_properties
  task.auto_detect_version_properties = true
  task.branch = 'user-provided-branch'
  task.consumer_version = nil
  task.pact_broker_base_url = ENV['PACT_BROKER_BASE_URL']
  task.pact_broker_token = ENV['PACT_BROKER_TOKEN']
  task.build_url = PactBroker::Client::Git.build_url
end

PactBroker::Client::PublicationTask.new(:pactflow_auto_off_user_commit_nil_branch) do | task |
  require 'pact_broker/client/version'
  # accept publish without branch, but has user provided commit
  # auto_detect_version_properties off
  task.auto_detect_version_properties = false
  task.branch = nil
  task.consumer_version = 'user-provided-version'
  task.pact_broker_base_url = ENV['PACT_BROKER_BASE_URL']
  task.pact_broker_token = ENV['PACT_BROKER_TOKEN']
  task.build_url = PactBroker::Client::Git.build_url
end

PactBroker::Client::PublicationTask.new(:pactflow_auto_off_nil_commit_nil_branch) do | task |
  require 'pact_broker/client/version'
  # reject publish without user provided commit
  # auto_detect_version_properties off
  task.auto_detect_version_properties = false
  task.branch = nil
  task.consumer_version = nil
  task.pact_broker_base_url = ENV['PACT_BROKER_BASE_URL']
  task.pact_broker_token = ENV['PACT_BROKER_TOKEN']
  task.build_url = PactBroker::Client::Git.build_url
end
PactBroker::Client::PublicationTask.new(:pactflow_auto_off_empty_string_commit_nil_branch) do | task |
  require 'pact_broker/client/version'
  # reject publish without user provided commit
  # auto_detect_version_properties off
  task.auto_detect_version_properties = false
  task.branch = nil
  task.consumer_version = ''
  task.pact_broker_base_url = ENV['PACT_BROKER_BASE_URL']
  task.pact_broker_token = ENV['PACT_BROKER_TOKEN']
  task.build_url = PactBroker::Client::Git.build_url
end
