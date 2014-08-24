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
          JSON.parse(response.body)["_links"]["latest-pact"]["href"]
        end
      end

      def get options
        url = get_consumer_contract_url(options)
        response = self.class.get(url, headers: default_get_headers)
        handle_response(response) do
          response.body
        end
      end

      def list_latest
        response = self.class.get("/pacts/latest", headers: default_get_headers)
        handle_response(response) do
          map_pact_list_to_hash JSON.parse(response.body)["pacts"]
        end
      end

      def latest options
        url = get_latest_consumer_contract_url(options)
        response = self.class.get(url, headers: default_get_headers)
        handle_response(response) do
          response.body
        end
      end

      private

      #TODO Move into mapper class
      def map_pact_list_to_hash pacts_list
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

      def find_latest_consumer_contract_query options
        query = {:consumer => options[:consumer], :provider => options[:provider]}
        query[:tag] = options[:tag] if options[:tag]
        query
      end

      def get_latest_consumer_contract_url options
        consumer_name = encode_param(options[:consumer])
        provider_name = encode_param(options[:provider])
        tag = options[:tag] ? "/#{options[:tag]}" : ""
        "/pacts/provider/#{provider_name}/consumer/#{consumer_name}/latest#{tag}"
      end

      def get_consumer_contract_url options
        consumer_name = encode_param(options[:consumer])
        provider_name = encode_param(options[:provider])
        consumer_version = encode_param(options[:consumer_version])
        "/pacts/provider/#{provider_name}/consumer/#{consumer_name}/version/#{consumer_version}"
      end

      def save_consumer_contract_url consumer_contract, consumer_version
        consumer_name = encode_param(consumer_contract.consumer.name)
        provider_name = encode_param(consumer_contract.provider.name)
        version = encode_param(consumer_version)
        "/pacts/provider/#{provider_name}/consumer/#{consumer_name}/version/#{version}"
      end
    end
  end
end