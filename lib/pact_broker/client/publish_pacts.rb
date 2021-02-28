require 'term/ansicolor'
require 'pact_broker/client'
require 'pact_broker/client/retry'
require 'pact_broker/client/pact_file'
require 'pact_broker/client/pact_hash'
require 'pact_broker/client/merge_pacts'
require 'pact_broker/client/hal_client_methods'
require 'pact_broker/client/hash_refinements'

module PactBroker
  module Client
    class PublishPacts
      using PactBroker::Client::HashRefinements
      include HalClientMethods

      def self.call(pact_broker_base_url, pact_file_paths, consumer_version_params, pact_broker_client_options={})
        new(pact_broker_base_url, pact_file_paths, consumer_version_params, pact_broker_client_options).call
      end

      def initialize pact_broker_base_url, pact_file_paths, consumer_version_params, pact_broker_client_options={}
        @pact_broker_base_url = pact_broker_base_url
        @pact_file_paths = pact_file_paths
        @consumer_version_number = consumer_version_params[:number].respond_to?(:strip) ? consumer_version_params[:number].strip : consumer_version_params[:number]
        @branch = consumer_version_params[:branch]
        @build_url = consumer_version_params[:build_url]
        @tags = consumer_version_params[:tags] ? consumer_version_params[:tags].collect{ |tag| tag.respond_to?(:strip) ? tag.strip : tag } : []
        @version_required = consumer_version_params[:version_required]
        @pact_broker_client_options = pact_broker_client_options
      end

      def call
        validate
        $stdout.puts("")
        result = create_consumer_versions && apply_tags && publish_pacts
        $stdout.puts("")
        result
      end

      private

      attr_reader :pact_broker_base_url, :pact_file_paths, :consumer_version_number, :branch, :tags, :build_url, :pact_broker_client_options, :version_required

      def pact_broker_client
        @pact_broker_client ||= PactBroker::Client::PactBrokerClient.new(base_url: pact_broker_base_url, client_options: pact_broker_client_options)
      end

      def index_entry_point
        @index_entry_point ||= create_index_entry_point(pact_broker_base_url, pact_broker_client_options)
      end

      def index_resource
        @index_resource ||= Retry.while_error do
          index_entry_point.get!
        end
      end

      def can_create_version_with_branch?
        @can_create_version_with_branch ||= index_resource.can?('pb:pacticipant-version')
      end

      def merge_on_server?
        pact_broker_client_options[:write] == :merge
      end

      def publish_pacts
        pact_files.group_by(&:pact_name).collect do | pact_name, pact_files |
          $stdout.puts "Merging #{pact_files.collect(&:path).join(", ")}" if pact_files.size > 1
          publish_pact(PactHash[merge_contents(pact_files)])
        end.all?
      end

      def merge_contents(pact_files)
        MergePacts.call(pact_files.collect(&:pact_hash))
      end

      def pact_files
        @pact_files ||= pact_file_paths.collect{ |pact_file_path| PactFile.new(pact_file_path) }
      end

      def consumer_names
        pact_files.collect(&:consumer_name).uniq
      end

      def publish_pact pact
        begin
          $stdout.puts "Publishing #{pact.pact_name} to pact broker at #{pact_broker_base_url}"
          publish_pact_contents pact
        rescue => e
          $stderr.puts "Failed to publish #{pact.pact_name} due to error: #{e.class} - #{e}"
          false
        end
      end

      def create_consumer_versions
        if create_versions?
          consumer_names.collect do | consumer_name |
            create_version(index_resource, consumer_name)
          end
          true
        else
          true
        end
      end

      def create_versions?
        if version_required
          if can_create_version_with_branch?
            true
          else
            raise PactBroker::Client::Error.new("This version of the Pact Broker does not support versions with branches or build URLs. Please upgrade your broker to 2.76.2 or later.")
          end
        elsif (branch || build_url) && can_create_version_with_branch?
          true
        else
          false
        end
      end

      def create_version(index_resource, consumer_name)
        Retry.while_error do
          version_resource = index_resource._link('pb:pacticipant-version').expand(version: consumer_version_number, pacticipant: consumer_name).put(version_body).assert_success!
          message = if version_resource.response.status == 200
            "Replaced version #{consumer_version_number} of #{consumer_name}"
          else
            "Created version #{consumer_version_number} of #{consumer_name}"
          end

          message = message + " (branch #{branch})" if branch
          $stdout.puts message
          if version_resource.response.status == 200
            $stdout.puts ::Term::ANSIColor.yellow("Replacing the version resource is not recommended under normal circumstances and may indicate that you have not configured your Pact pipeline correctly (unless you are just re-running a build for a particular commit). For more information see https://docs.pact.io/versioning")
          end
          true
        end
      end

      def version_body
        {
          branch: branch,
          buildUrl: build_url
        }.compact
      end

      def apply_tags
        return true if tags.empty?
        tags.all? do | tag |
          tag_consumer_version tag
        end
      end

      def tag_consumer_version tag
        versions = pact_broker_client.pacticipants.versions
        Retry.while_error do
          consumer_names.collect do | consumer_name |
            versions.tag(pacticipant: consumer_name, version: consumer_version_number, tag: tag)
            $stdout.puts "Tagged version #{consumer_version_number} of #{consumer_name} as #{tag.inspect}"
            true
          end
        end
      rescue => e
        $stderr.puts "Failed to tag version due to error: #{e.class} - #{e}"
        false
      end

      def publish_pact_contents(pact)
        Retry.while_error do
          pacts = pact_broker_client.pacticipants.versions.pacts
          if pacts.version_published?(consumer: pact.consumer_name, provider: pact.provider_name, consumer_version: consumer_version_number)
            if merge_on_server?
              $stdout.puts "A pact for this consumer version is already published. Merging contents."
            else
              $stdout.puts ::Term::ANSIColor.yellow("A pact for this consumer version is already published. Overwriting. (Note: Overwriting pacts is not recommended as it can lead to race conditions. Best practice is to provide a unique consumer version number for each publication. For more information, see https://docs.pact.io/versioning)")
            end
          end

          latest_pact_url = pacts.publish(pact_hash: pact, consumer_version: consumer_version_number)
          $stdout.puts "The latest version of this pact can be accessed at the following URL:\n#{latest_pact_url}"
          true
        end
      end

      def validate
        raise PactBroker::Client::Error.new("Please specify the consumer_version_number") unless (consumer_version_number && consumer_version_number.to_s.strip.size > 0)
        raise PactBroker::Client::Error.new("Please specify the pact_broker_base_url") unless (pact_broker_base_url && pact_broker_base_url.to_s.strip.size > 0)
        raise PactBroker::Client::Error.new("No pact files found") unless (pact_file_paths && pact_file_paths.any?)
      end
    end
  end
end
