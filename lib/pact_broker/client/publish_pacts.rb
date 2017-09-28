require 'term/ansicolor'
require 'pact_broker/client'
require 'pact_broker/client/retry'

module PactBroker
  module Client
    class PublishPacts

      def self.call(pact_broker_base_url, pact_files, consumer_version, tags, pact_broker_client_options={})
        new(pact_broker_base_url, pact_files, consumer_version, tags, pact_broker_client_options).call
      end

      def initialize pact_broker_base_url, pact_files, consumer_version, tags, pact_broker_client_options={}
        @pact_broker_base_url = pact_broker_base_url
        @pact_files = pact_files
        @consumer_version = consumer_version
        @tags = tags
        @pact_broker_client_options = pact_broker_client_options
      end

      def call
        validate
        $stdout.puts("")
        result = apply_tags && publish_pacts
        $stdout.puts("")
        result
      end

      private

      attr_reader :pact_broker_base_url, :pact_files, :consumer_version, :tags, :pact_broker_client_options

      def pact_broker_client
        @pact_broker_client ||= PactBroker::Client::PactBrokerClient.new(base_url: pact_broker_base_url, client_options: pact_broker_client_options)
      end

      def publish_pacts
        pact_files.collect{ | pact_file | publish_pact pact_file }.all?
      end

      def publish_pact pact_file
        begin
          $stdout.puts ">> Publishing #{pact_file} to pact broker at #{pact_broker_base_url}"
          publish_pact_contents File.read(pact_file)
        rescue => e
          $stderr.puts "Failed to publish pact: #{pact_file} due to error: #{e.to_s}\n#{e.backtrace.join("\n")}"
          false
        end
      end

      def apply_tags
        return true if tags.nil? || tags.empty?
        tags.all? do | tag |
          tag_consumer_version tag
        end
      end

      def tag_consumer_version tag
        versions = pact_broker_client.pacticipants.versions
        Retry.until_true do
          $stdout.puts "Tagging version #{consumer_version} of #{consumer_name} as #{tag.inspect}"
          versions.tag(pacticipant: consumer_name, version: consumer_version, tag: tag)
          true
        end
      rescue => e
        $stderr.puts "Failed to tag version #{consumer_version} of #{consumer_name} due to error: #{e.to_s}\n#{e.backtrace.join("\n")}"
        false
      end

      def publish_pact_contents(pact_file_contents)
        Retry.until_true do
          contract = contract_from_file(pact_file_contents)
          pacts = pact_broker_client.pacticipants.versions.pacts
          if pacts.version_published?(consumer: contract.consumer.name, provider: contract.provider.name, consumer_version: consumer_version)
            $stdout.puts ::Term::ANSIColor.yellow("The given version of pact is already published. Will Overwrite...")
          end

          latest_pact_url = pacts.publish(pact_json: pact_file_contents, consumer_version: consumer_version)
          $stdout.puts "The latest version of this pact can be accessed at the following URL (use this to configure the provider verification):\n#{latest_pact_url}"
          true
        end
      end

      def consumer_name
        contract_from_file(File.read(pact_files.first)).consumer.name
      end

      def contract_from_file pact_file_contents
        ::Pact::ConsumerContract.from_json(pact_file_contents)
      end

      def validate
        raise "Please specify the consumer_version" unless (consumer_version && consumer_version.to_s.strip.size > 0)
        raise "Please specify the pact_broker_base_url" unless (pact_broker_base_url && pact_broker_base_url.to_s.strip.size > 0)
        raise "No pact files found" unless (pact_files && pact_files.any?)
      end

    end
  end
end
