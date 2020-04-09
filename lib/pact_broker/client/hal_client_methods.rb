require 'pact_broker/client/hal'

module PactBroker
  module Client
    module HalClientMethods
      def create_index_entry_point(pact_broker_base_url, pact_broker_client_options)
        PactBroker::Client::Hal::EntryPoint.new(pact_broker_base_url, create_http_client(pact_broker_client_options))
      end

      def create_http_client(pact_broker_client_options)
        PactBroker::Client::Hal::HttpClient.new(pact_broker_client_options.merge(pact_broker_client_options[:basic_auth] || {}))
      end
    end
  end
end
