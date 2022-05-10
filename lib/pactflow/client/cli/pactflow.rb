require "pactflow/client/cli/provider_contract_commands"
require "pact_broker/client/cli/custom_thor"

module Pactflow
  module Client
    module CLI
      class Pactflow < PactBroker::Client::CLI::CustomThor
        include ::Pactflow::Client::CLI::ProviderContractCommands
      end
    end
  end
end
