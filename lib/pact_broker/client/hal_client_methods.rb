require 'pact_broker/client/hal'
require 'pact_broker/client/retry'

module PactBroker
  module Client
    module HalClientMethods
      def create_index_entry_point(pact_broker_base_url, pact_broker_client_options)
        PactBroker::Client::Hal::EntryPoint.new(pact_broker_base_url, create_http_client(pact_broker_client_options))
      end

      def create_entry_point(entry_point, pact_broker_client_options)
        PactBroker::Client::Hal::EntryPoint.new(entry_point, create_http_client(pact_broker_client_options))
      end

      def create_http_client(pact_broker_client_options)
        PactBroker::Client::Hal::HttpClient.new(pact_broker_client_options.merge(pact_broker_client_options[:basic_auth] || {}))
      end

      def index_entry_point
        @index_entry_point ||= create_index_entry_point(pact_broker_base_url, pact_broker_client_options)
      end

      def index_resource
        @index_resource ||= index_entry_point.get!
      end

      def is_pactflow?
        index_resource.response.headers.keys.any?{ | header_name | header_name.downcase.include?("pactflow") }
      end

      def pact_broker_name
        is_pactflow? ? "Pactflow" : "the Pact Broker"
      end
    end
  end
end
