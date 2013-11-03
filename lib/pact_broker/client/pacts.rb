require 'pact/consumer_contract'
require_relative 'base_client'


module PactBroker
  module Client
    class Pacts  < BaseClient

      def publish options
        consumer_version = options[:consumer_version]
        pact_string = options[:pact_json]
        consumer_contract = ::Pact::ConsumerContract.from_json pact_string
        url = save_consumer_contract_url consumer_contract, consumer_version
        response = self.class.put(url, body: pact_string, headers: default_put_headers)
        handle_response(response) do
          true
        end
      end

      def last options
        url = find_last_consumer_contract_url options
        query = options[:tag] ? {tag: options[:tag]} : {}
        response = self.class.get(url, headers: default_get_headers, query: query)
        handle_response(response) do
          response.body
        end
      end

      private

      def find_last_consumer_contract_url options
        consumer_name = encode_param(options[:consumer])
        provider_name = encode_param(options[:provider])
        "/pacticipants/#{consumer_name}/versions/last/pacts/#{provider_name}"
      end

      def save_consumer_contract_url consumer_contract, consumer_version
        consumer_name = encode_param(consumer_contract.consumer.name)
        provider_name = encode_param(consumer_contract.provider.name)
        version = encode_param(consumer_version)
        "/pacticipants/#{consumer_name}/versions/#{version}/pacts/#{provider_name}"
      end
    end
  end
end