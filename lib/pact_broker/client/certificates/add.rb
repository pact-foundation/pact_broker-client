require 'pact_broker/client/command_result'
require 'pact_broker/client/hal'

module PactBroker
  module Client
    module Certificates
      class Add
        def self.call(params, broker_base_url, pact_broker_client_options)
          new(params, broker_base_url, pact_broker_client_options).call
        end

        def initialize(params, broker_base_url, pact_broker_client_options)
          @params = params
          @broker_base_url = broker_base_url
          @pact_broker_client_options = pact_broker_client_options
        end

        def call
          # TODO
          CommandResult.new(false, "some message")
        end

        private

        attr_reader :params, :broker_base_url, :pact_broker_client_options
      end
    end
  end
end
