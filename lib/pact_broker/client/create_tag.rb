require 'pact_broker/client/error'
require 'pact_broker/client/pact_broker_client'
require 'pact_broker/client/retry'

module PactBroker
  module Client
    class CreateTag

      class Result
        attr_reader :success, :message

        def initialize success, message = nil
          @success = success
          @message = message
        end
      end

      def self.call(pact_broker_base_url, pacticipant_name, version, tags, pact_broker_client_options={})
        new(pact_broker_base_url, pacticipant_name, version, tags, pact_broker_client_options).call
      end

      def initialize(pact_broker_base_url, pacticipant_name, version, tags, pact_broker_client_options)
        @pact_broker_base_url = pact_broker_base_url
        @pacticipant_name = pacticipant_name
        @version = version
        @tags = tags
        @pact_broker_client_options = pact_broker_client_options
      end

      def call
        tags.each do | tag |
          # todo check that pacticipant exists first
          $stdout.puts "Tagging #{pacticipant_name} version #{version} as #{tag}"
          Retry.while_error do
            pact_broker_client.pacticipants.versions.tag pacticipant: pacticipant_name, version: version, tag: tag
          end
        end
      end

      private

      attr_reader :pact_broker_base_url, :pacticipant_name, :version, :tags, :pact_broker_client_options

      def pact_broker_client
        @pact_broker_client ||= PactBroker::Client::PactBrokerClient.new(base_url: pact_broker_base_url, client_options: pact_broker_client_options)
      end
    end
  end
end
