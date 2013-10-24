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
        @pattern = FileList['spec/pacts/*.json']
        yield self
        rake_task
      end

      def rake_task

        require 'pact_broker/client'
        PactBroker::Client.new()

      end

    end
  end
end