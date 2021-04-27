require 'rake/tasklib'
require 'pact_broker/client/git'
require 'pact_broker/client/hash_refinements'

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
      using PactBroker::Client::HashRefinements

      attr_accessor :pattern, :pact_broker_base_url, :consumer_version, :tag, :write_method, :tag_with_git_branch, :pact_broker_basic_auth, :pact_broker_token
      attr_reader :auto_detect_version_properties, :branch, :build_url
      alias_method :tags=, :tag=
      alias_method :tags, :tag

      def initialize name = nil, &block
        @name = name
        @auto_detect_version_properties = nil
        @version_required = false
        @pattern = 'spec/pacts/*.json'
        @pact_broker_base_url = 'http://pact-broker'
        rake_task &block
      end

      def auto_detect_version_properties= auto_detect_version_properties
        @version_required = version_required || auto_detect_version_properties
        @auto_detect_version_properties = auto_detect_version_properties
      end

      def branch= branch
        @version_required = version_required || !!branch
        @branch = branch
      end

      def build_url= build_url
        @version_required = version_required || !!build_url
        @build_url = build_url
      end

      private

      attr_reader :version_required

      def rake_task &block
        namespace :pact do
          desc "Publish pacts to pact broker"
          task task_name do
            block.call(self)
            require 'pact_broker/client/publish_pacts'
            pact_broker_client_options = { write: write_method, token: pact_broker_token }
            pact_broker_client_options[:basic_auth] = pact_broker_basic_auth if pact_broker_basic_auth && pact_broker_basic_auth.any?
            pact_broker_client_options.compact!
            consumer_version_params = { number: consumer_version, branch: the_branch, build_url: build_url, tags: all_tags, version_required: version_required }.compact
            result = PactBroker::Client::PublishPacts.new(pact_broker_base_url, FileList[pattern], consumer_version_params, {}, pact_broker_client_options).call
            $stdout.puts result.message
            raise "One or more pacts failed to be published" unless result.success
          end
        end
      end

      def task_name
        @name ? "publish:#{@name}" : "publish"
      end

      def all_tags
        t = [*tags]
        t << PactBroker::Client::Git.branch(raise_error: true) if tag_with_git_branch
        t.compact.uniq
      end

      def the_branch
        if branch.nil? && auto_detect_version_properties != false
          PactBroker::Client::Git.branch(raise_error: auto_detect_version_properties == true)
        else
          branch
        end
      end
    end
  end
end
