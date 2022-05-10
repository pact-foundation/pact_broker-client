require "pact_broker/client/cli/custom_thor"
require "pact_broker/client/hash_refinements"
require "thor/error"
require "pact_broker/client/cli/pact_commands"
require "pact_broker/client/cli/environment_commands"
require "pact_broker/client/cli/deployment_commands"
require "pact_broker/client/cli/pacticipant_commands"
require "pact_broker/client/cli/version_commands"
require "pact_broker/client/cli/webhook_commands"
require "pact_broker/client/cli/matrix_commands"

module PactBroker
  module Client
    module CLI
      class Broker < CustomThor
        include PactBroker::Client::CLI::PactCommands
        include PactBroker::Client::CLI::EnvironmentCommands
        include PactBroker::Client::CLI::DeploymentCommands
        include PactBroker::Client::CLI::MatrixCommands
        include PactBroker::Client::CLI::PacticipantCommands
        include PactBroker::Client::CLI::VersionCommands
        include PactBroker::Client::CLI::WebhookCommands

        ignored_and_hidden_potential_options_from_environment_variables
        desc "generate-uuid", "Generate a UUID for use when calling create-or-update-webhook"
        def generate_uuid
          require "securerandom"
          puts SecureRandom.uuid
        end

        ignored_and_hidden_potential_options_from_environment_variables
        desc "version", "Show the pact_broker-client gem version"
        def version
          require "pact_broker/client/version"
          $stdout.puts PactBroker::Client::VERSION
        end
      end
    end
  end
end
