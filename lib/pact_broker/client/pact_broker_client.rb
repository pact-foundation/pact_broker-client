require 'pact_broker/client/pacticipants'
require 'pact_broker/client/versions'
require 'pact_broker/client/pacts'
require 'pact_broker/client/matrix'

module PactBroker
  module Client

    DEFAULT_PACT_BROKER_BASE_URL = 'http://pact-broker'

    class PactBrokerClient

      DEFAULT_OPTIONS = {base_url: DEFAULT_PACT_BROKER_BASE_URL}

      attr_reader :base_url, :client_options

      def initialize options = {}
        merged_options = DEFAULT_OPTIONS.merge(options)
        @base_url = merged_options[:base_url]
        @client_options = merged_options[:client_options] || {}
      end

      def pacticipants
        PactBroker::Client::Pacticipants.new base_url: base_url, client_options: client_options
      end

      def pacts
        PactBroker::Client::Pacts.new base_url: base_url, client_options: client_options
      end

      def matrix
        PactBroker::Client::Matrix.new base_url: base_url, client_options: client_options
      end
    end
  end
end
