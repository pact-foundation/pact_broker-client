require 'pact_broker/client'
require 'pact_broker/client/retry'

module PactBroker
  module Client
    class PublishPacts

      def initialize pact_broker_base_url, pact_files, consumer_version
        @pact_broker_base_url = pact_broker_base_url
        @pact_files = pact_files
        @consumer_version = consumer_version
      end

      def call
        validate
        $stdout.puts("")
        pact_files.collect{ | pact_file | publish_pact pact_file }.all?
      end

      private

      attr_reader :pact_broker_base_url, :pact_files, :consumer_version

      def pact_broker_client
        @pact_broker_client ||= PactBroker::Client::PactBrokerClient.new(base_url: pact_broker_base_url)
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

      def publish_pact_contents pact_file_contents
        Retry.until_true do
          latest_pact_url = pact_broker_client.pacticipants.versions.pacts.publish(pact_json: pact_file_contents, consumer_version: consumer_version)
          $stdout.puts "The latest version of this pact can be accessed at the following URL (use this to configure the provider verification):\n#{latest_pact_url}\n\n"
          true
        end
      end

      def validate
        raise "Please specify the consumer_version" unless (consumer_version && consumer_version.to_s.strip.size > 0)
        raise "Please specify the pact_broker_base_url" unless (pact_broker_base_url && pact_broker_base_url.to_s.strip.size > 0)
        raise "No pact files found" unless (pact_files && pact_files.any?)
      end

    end
  end
end
