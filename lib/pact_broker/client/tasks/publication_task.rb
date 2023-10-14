require 'rake/tasklib'
require 'pact_broker/client/git'
require 'pact_broker/client/hash_refinements'
require 'pact_broker/client/string_refinements'
require "pact_broker/client/error"

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
      using PactBroker::Client::StringRefinements

      attr_accessor :pattern, :pact_broker_base_url, :tag, :build_url, :write_method, :tag_with_git_branch, :pact_broker_basic_auth, :pact_broker_token
      attr_reader :auto_detect_version_properties, :build_url
      attr_writer :consumer_version, :branch
      alias_method :tags=, :tag=
      alias_method :tags, :tag

      def initialize name = nil, &block
        @name = name
        @auto_detect_version_properties = nil
        @pattern = 'spec/pacts/*.json'
        @pact_broker_base_url = 'http://pact-broker'
        rake_task &block
      end

      def auto_detect_version_properties= auto_detect_version_properties
        @auto_detect_version_properties = auto_detect_version_properties
      end
      
      private

      def rake_task &block
        namespace :pact do
          desc "Publish pacts to pact broker"
          task task_name do
            block.call(self)
            validate!
            require 'pact_broker/client/publish_pacts'
            pact_broker_client_options = { write: write_method, token: pact_broker_token }
            pact_broker_client_options[:basic_auth] = pact_broker_basic_auth if pact_broker_basic_auth && pact_broker_basic_auth.any?
            pact_broker_client_options.compact!
            consumer_version_params = { number: consumer_version, branch: branch, build_url: build_url, tags: all_tags }.compact
            result = PactBroker::Client::PublishPacts.new(pact_broker_base_url, FileList[pattern], consumer_version_params, {}, pact_broker_client_options).call
            $stdout.puts result.message
            raise PactBroker::Client::Error.new("One or more pacts failed to be published") unless result.success
          end
        end
      end

      def validate!
        if consumer_version.blank?
          raise PactBroker::Client::Error.new("A consumer version must be provided")
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

      # Attempt to detect the branch automatically, but don't raise an error if the branch can't be found
      # unless the user has explicitly enabled auto_detect_version_properties.
      # This approach is an attempt to include the branch without the user having to explicitly
      # set it, because people tend to not update things.
      def branch
        if @branch.nil? && auto_detect_version_properties != false
          @branch = PactBroker::Client::Git.branch(raise_error: auto_detect_version_properties == true)
        else
          @branch
        end
      end

      def consumer_version
        if @consumer_version.nil? && @auto_detect_version_properties
          @consumer_version = PactBroker::Client::Git.commit(raise_error: true)
        else
          @consumer_version
        end
      end

      def build_url
        if @build_url.nil? && @auto_detect_version_properties
          @build_url = PactBroker::Client::Git.build_url
        else
          @build_url
        end
      end
    end
  end
end
