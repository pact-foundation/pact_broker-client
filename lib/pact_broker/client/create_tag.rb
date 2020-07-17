require 'pact_broker/client/error'
require 'pact_broker/client/pact_broker_client'
require 'pact_broker/client/retry'

module PactBroker
  module Client
    class CreateTag

      def self.call(pact_broker_base_url, pacticipant_name, version, tags, auto_create_version, pact_broker_client_options={})
        new(pact_broker_base_url, pacticipant_name, version, tags, auto_create_version, pact_broker_client_options).call
      end

      def initialize(pact_broker_base_url, pacticipant_name, version, tags, auto_create_version, pact_broker_client_options)
        @pact_broker_base_url = pact_broker_base_url
        @pacticipant_name = pacticipant_name
        @version = version
        @tags = tags
        @auto_create_version = auto_create_version
        @pact_broker_client_options = pact_broker_client_options
      end

      def call
        ensure_version_exists if !auto_create_version
        tags.each do | tag |
          $stdout.puts "Tagging #{pacticipant_name} version #{version} as #{tag}"
          Retry.while_error do
            pact_broker_client.pacticipants.versions.tag pacticipant: pacticipant_name, version: version, tag: tag
          end
        end
      end

      private

      attr_reader :pact_broker_base_url, :pacticipant_name, :version, :tags, :auto_create_version, :pact_broker_client_options

      def pact_broker_client
        @pact_broker_client ||= PactBroker::Client::PactBrokerClient.new(base_url: pact_broker_base_url, client_options: pact_broker_client_options)
      end

      def ensure_version_exists
        if pact_broker_client.pacticipants.versions.find(pacticipant: pacticipant_name, version: version).nil?
          raise PactBroker::Client::Error.new("Could not create tag. Version #{version} of #{pacticipant_name} does not exist.")
        end
      end
    end
  end
end
