require 'pact_broker/client/hal'
require 'pact_broker/client/command_result'

module PactBroker
  module Client
    module Webhooks
      class Test
        def self.call(options, pact_broker_client_options)
          http_client = PactBroker::Client::Hal::HttpClient.new(pact_broker_client_options.merge(pact_broker_client_options[:basic_auth] || {}))
          execution_result = PactBroker::Client::Hal::EntryPoint.new(options.broker_base_url, http_client).get!._link!('pb:webhook').expand('uuid' => options.uuid).get!.post('pb:execute')
          PactBroker::Client::CommandResult.new(true, execution_result.response.body['logs'])
        end
      end
    end
  end
end
