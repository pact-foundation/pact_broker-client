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

      attr_accessor :pattern, :pact_broker_base_url, :consumer_version, :overwrite_method, :pact_broker_basic_auth

      def initialize name = nil, &block
        @name = name
        @pattern = 'spec/pacts/*.json'
        @pact_broker_base_url = 'http://pact-broker'
        rake_task &block
      end

      private

      def rake_task &block
        namespace :pact do
          desc "Publish pacts to pact broker"
          task task_name do
            block.call(self)
            require 'pact_broker/client/publish_pacts'
            basic_auth_client_options = pact_broker_basic_auth ? {basic_auth: pact_broker_basic_auth} : {}
            pact_broker_client_options = basic_auth_client_options.merge(overwrite_method ? {overwrite: overwrite_method} : {})
            success = PactBroker::Client::PublishPacts.new(pact_broker_base_url, FileList[pattern], consumer_version, pact_broker_client_options).call
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
