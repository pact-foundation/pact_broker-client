require 'pact_broker/client/hal'
require 'pact_broker/client/retry'

module PactBroker
  module Client
    module HalClientMethods
      def create_index_entry_point(pact_broker_base_url, pact_broker_client_options)
        PactBroker::Client::Hal::EntryPoint.new(pact_broker_base_url, create_http_client(pact_broker_client_options))
      end

      def create_http_client(pact_broker_client_options)
        PactBroker::Client::Hal::HttpClient.new(pact_broker_client_options.merge(pact_broker_client_options[:basic_auth] || {}))
      end

      def index_entry_point
        @index_entry_point ||= create_index_entry_point(pact_broker_base_url, pact_broker_client_options)
      end

      def index_resource
        @index_resource ||= Retry.while_error do
          index_entry_point.get!
        end
      end
    end
  end
end
