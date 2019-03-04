require 'rake/tasklib'
require 'pact_broker/client/git'

=begin
require pact_broker/client/tasks

PactBroker::Client::PublicationTask.new do | task |
  require 'consumer/version'
  task.pact_broker_base_url = 'http://pact-broker'
  task.consumer_version = Consumer::VERSION
  task.tags = ["dev"]
  task.tag_with_git_branch = true
end

=end

module PactBroker
  module Client
    class PublicationTask < ::Rake::TaskLib

      attr_accessor :pattern, :pact_broker_base_url, :consumer_version, :tag, :write_method, :tag_with_git_branch, :pact_broker_basic_auth, :pact_broker_token
      alias_method :tags=, :tag=
      alias_method :tags, :tag

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
            pact_broker_client_options =  {}
              .merge( pact_broker_basic_auth ? { basic_auth: pact_broker_basic_auth } : {} )
              .merge( write_method ? { write: write_method } : {} )
              .merge( pact_broker_token ? { token: pact_broker_token } : {} )
            success = PactBroker::Client::PublishPacts.new(pact_broker_base_url, FileList[pattern], consumer_version, all_tags, pact_broker_client_options).call
            raise "One or more pacts failed to be published" unless success
          end
        end
      end

      def task_name
        @name ? "publish:#{@name}" : "publish"
      end

      def all_tags
        t = [*tags]
        t << PactBroker::Client::Git.branch if tag_with_git_branch
        t.compact.uniq
      end
    end
  end
end
