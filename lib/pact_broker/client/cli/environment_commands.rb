module PactBroker
  module Client
    module CLI
      module EnvironmentCommands
        ENVIRONMENT_PARAM_NAMES = [:name, :display_name, :production, :contact_name, :contact_email_address, :output]

        def self.included(thor)
          thor.class_eval do

            ignored_and_hidden_potential_options_from_environment_variables
            desc "create-environment", "Create an environment resource in the Pact Broker to represent a real world deployment or release environment."
            shared_environment_options
            shared_authentication_options
            def create_environment
              require 'pact_broker/client/environments/create_environment'
              params = ENVIRONMENT_PARAM_NAMES.each_with_object({}) { | key, p | p[key] = options[key] }
              result = PactBroker::Client::Environments::CreateEnvironment.call(params, options.broker_base_url, pact_broker_client_options)
              $stdout.puts result.message
              exit(1) unless result.success
            end

            desc "delete-environment", "Delete an environment"
            method_option :uuid, required: true, desc: "The UUID of the environment to delete"
            method_option :output, aliases: "-o", desc: "json or text", default: 'text'
            shared_authentication_options
            def delete_environment
              require 'pact_broker/client/environments/delete_environment'
              params = { uuid: options.uuid, output: options.output }
              result = PactBroker::Client::Environments::DeleteEnvironment.call(params, options.broker_base_url, pact_broker_client_options)
              $stdout.puts result.message
              exit(1) unless result.success
            end

            ignored_and_hidden_potential_options_from_environment_variables
            desc "update-environment", "Update an environment resource in the Pact Broker."
            method_option :uuid, required: true, desc: "The UUID of the environment to update"
            shared_environment_options
            shared_authentication_options

            def update_environment
              require 'pact_broker/client/environments/update_environment'
              params = (ENVIRONMENT_PARAM_NAMES + [:uuid]).each_with_object({}) { | key, p | p[key] = options[key] }
              result = PactBroker::Client::Environments::UpdateEnvironment.call(params, options.broker_base_url, pact_broker_client_options)
              $stdout.puts result.message
              exit(1) unless result.success
            end
          end
        end
      end
    end
  end
end
