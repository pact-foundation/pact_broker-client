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

      def latest
        response = self.class.get("/pacts/latest", headers: default_get_headers)
        handle_response(response) do
          map_pact_list_do_hash response.to_hash["pacts"]
        end
      end

      def last options
        query = find_last_consumer_contract_query(options)
        response = self.class.get("/pacts/latest", headers: default_get_headers, query: query)
        handle_response(response) do
          response.body
        end
      end

      private

      #TODO Move into mapper class
      def map_pact_list_do_hash pacts_list
        pacts_list.collect do | pact_hash |
          {
            consumer: {
              name: pact_hash["_embedded"]["consumer"]["name"],
              version: {
                number: pact_hash["_embedded"]["consumer"]["_embedded"]["version"]["number"]
              }
            },
            provider: {
              name: pact_hash["_embedded"]["provider"]["name"]
            }
          }
        end
      end

      def find_last_consumer_contract_query options
        query = {:consumer => options[:consumer], :provider => options[:provider]}
        query[:tag] = options[:tag] if options[:tag]
        query
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