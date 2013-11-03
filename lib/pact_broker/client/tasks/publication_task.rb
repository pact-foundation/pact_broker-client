require 'rake/tasklib'

=begin
require pact_broker/client/tasks

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

      def initialize name = nil
        @name = name
        @pattern = 'spec/pacts/*.json'
        @pact_broker_base_url = 'http://pact-broker'
        yield self
        rake_task
      end

      private

      def rake_task
        namespace :pact do
          task task_name do
            require 'pact_broker/client/publish_pacts'
            success = PactBroker::Client::PublishPacts.new(pact_broker_base_url, FileList[@pattern], consumer_version).call
            raise "One or more pacts failed to be published" unless success
          end
        end
      end

      def task_name
        @name ? "publish:#{@name}" : "publish"
      end

    end
  end
end