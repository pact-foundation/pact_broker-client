require 'pact_broker/client/hal'
require 'pact_broker/client/command_result'
require 'pact_broker/client/hal_client_methods'

module PactBroker
  module Client
    module Pacts
      class ListLatestVersions

        include HalClientMethods

        def self.call(pact_broker_base_url, output, pact_broker_client_options)
          new(pact_broker_base_url, output, pact_broker_client_options).call
        end

        def initialize(pact_broker_base_url, output, pact_broker_client_options)
          @index_entry_point = create_index_entry_point(pact_broker_base_url, pact_broker_client_options)
          @output = output
        end

        def call
          message = if output == 'json'
            versions_resource.response.raw_body
          else
            to_text(versions)
          end
          PactBroker::Client::CommandResult.new(true, message)

        rescue StandardError => e
          PactBroker::Client::CommandResult.new(false, e.message)
        end

        private

        attr_reader :index_entry_point, :output

        def versions
          versions_resource.pacts.collect do | pact |
            OpenStruct.new(
              consumer_name: pact['_embedded']['consumer']['name'],
              provider_name: pact['_embedded']['provider']['name'],
              consumer_version_number: pact['_embedded']['consumer']['_embedded']['version']['number'],
              created_at: pact['createdAt']
            )
          end
        end

        def versions_resource
          index_entry_point.get!._link('pb:latest-pact-versions').get!
        end

        def to_text(pacts)
          require 'table_print'
          options = [
            { consumer_name: {display_name: 'consumer'} },
            { consumer_version_number: {display_name: 'consumer_version'} },
            { provider_name: {display_name: 'provider'} },
            { created_at: {} }
          ]
          TablePrint::Printer.new(pacts, options).table_print
        end
      end
    end
  end
end
