require "pact_broker/client/cli/broker"
require "pactflow/client/cli/provider_contract_commands"

module Pactflow
  module Client
    module CLI
      class Pactflow < PactBroker::Client::CLI::Broker
        include ::Pactflow::Client::CLI::ProviderContractCommands
      end
    end
  end
end
