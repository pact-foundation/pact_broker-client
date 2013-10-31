require 'rake/tasklib'

=begin

PactBroker::Client::PublicationTask.new do | task |
  require 'consumer/version'
  task.pact_broker_base_url = 'http://pact-broker'
  task.consumer_version = Consumer::VERSION
end

=end

module PactBroker
  module Client

    class PublicationTask < ::Rake::TaskLib

      attr_accessor :pattern, :pact_broker_base_url, :consumer_version

      def initialize
        @pattern = 'spec/pacts/*.json'
        yield self
        rake_task
      end

      def rake_task

        namespace :pact do
          task :publish do
            require 'pact_broker/client'
            pact_broker_client = PactBroker::Client.new(base_url: pacticipant_base_url)
            PublishPacts.new(pact_broker_client, FileList[@pattern], consumer_version).call
          end
        end
      end

    end
  end
end