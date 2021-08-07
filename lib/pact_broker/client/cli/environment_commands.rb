module PactBroker
  module Client
    module CLI
      module EnvironmentCommands
        ENVIRONMENT_PARAM_NAMES = [:name, :display_name, :production, :contact_name, :contact_email_address]

        def self.included(thor)
          thor.class_eval do
            def self.shared_environment_options(name_required: false)
              method_option :name, required: name_required, desc: "The uniquely identifying name of the environment as used in deployment code"
              method_option :display_name, desc: "The display name of the environment"
              method_option :production, type: :boolean, default: false, desc: "Whether or not this environment is a production environment. Default: false"
              method_option :contact_name, required: false, desc: "The name of the team/person responsible for this environment"
              method_option :contact_email_address, required: false, desc: "The email address of the team/person responsible for this environment"
              output_option_json_or_text
            end

            desc "create-environment", "Create an environment resource in the Pact Broker to represent a real world deployment or release environment."
            shared_environment_options(name_required: true)
            shared_authentication_options
            def create_environment
              execute_environment_command(params_from_options(ENVIRONMENT_PARAM_NAMES), "CreateEnvironment")
            end

            desc "update-environment", "Update an environment resource in the Pact Broker."
            method_option :uuid, required: true, desc: "The UUID of the environment to update"
            shared_environment_options(name_required: false)
            shared_authentication_options
            def update_environment
              execute_environment_command(params_from_options(ENVIRONMENT_PARAM_NAMES + [:uuid]), "UpdateEnvironment")
            end

            desc "describe-environment", "Describe an environment"
            method_option :uuid, required: true, desc: "The UUID of the environment to describe"
            method_option :output, aliases: "-o", desc: "json or text", default: 'text'
            shared_authentication_options
            def describe_environment
              execute_environment_command(params_from_options([:uuid]), "DescribeEnvironment")
            end

            desc "list-environments", "List environments"
            method_option :output, aliases: "-o", desc: "json or text", default: 'text'
            shared_authentication_options
            def list_environments
              execute_environment_command({}, "ListEnvironments")
            end

            desc "delete-environment", "Delete an environment"
            method_option :uuid, required: true, desc: "The UUID of the environment to delete"
            method_option :output, aliases: "-o", desc: "json or text", default: 'text'
            shared_authentication_options
            def delete_environment
              execute_environment_command(params_from_options([:uuid]), "DeleteEnvironment")
            end

            no_commands do
              def execute_environment_command(params, command_class_name)
                require 'pact_broker/client/environments'
                command_options = { verbose: options.verbose, output: options.output }
                result = PactBroker::Client::Environments.const_get(command_class_name).call(params, command_options, pact_broker_client_options)
                $stdout.puts result.message
                exit(1) unless result.success
              end
            end
          end
        end
      end
    end
  end
end
