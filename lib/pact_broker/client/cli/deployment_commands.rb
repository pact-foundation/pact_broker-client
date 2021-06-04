module PactBroker
  module Client
    module CLI
      module DeploymentCommands
        def self.included(thor)
          thor.class_eval do
            ignored_and_hidden_potential_options_from_environment_variables
            desc "record-deployment", "Record deployment of a pacticipant version to an environment. See https://docs.pact.io/go/record_deployment for more information."
            method_option :pacticipant, required: true, aliases: "-a", desc: "The name of the pacticipant that was deployed."
            method_option :version, required: true, aliases: "-e", desc: "The pacticipant version number that was deployed."
            method_option :environment, required: true, desc: "The name of the environment that the pacticipant version was deployed to."
            method_option :target, default: nil, required: false, desc: "Optional. The target of the deployment - a logical identifer required to differentiate deployments when there are multiple instances of the same application in an environment."
            output_option_json_or_text
            shared_authentication_options

            def record_deployment
              params = {
                pacticipant_name: options.pacticipant,
                version_number: options.version,
                environment_name: options.environment,
                target: options.target
              }
              execute_deployment_command(params, "RecordDeployment")
            end

            ignored_and_hidden_potential_options_from_environment_variables
            desc "record-undeployment", "Record undeployment of (or the end of support for) a pacticipant version from an environment"
            method_option :pacticipant, required: true, aliases: "-a", desc: "The name of the pacticipant that was undeployed."
            method_option :version, required: true, aliases: "-e", desc: "The pacticipant version number that was undeployed."
            method_option :environment, required: true, desc: "The name of the environment that the pacticipant version was undeployed from."
            method_option :target, default: nil, required: false, desc: "Optional. The target that the application is being undeployed from - a logical identifer required to differentiate deployments when there are multiple instances of the same application in an environment."
            output_option_json_or_text
            shared_authentication_options

            def record_undeployment
              params = {
                pacticipant_name: options.pacticipant,
                version_number: options.version,
                environment_name: options.environment,
                target: options.target
              }
              execute_deployment_command(params, "RecordUndeployment")
            end

            no_commands do
              def execute_deployment_command(params, command_class_name)
                require 'pact_broker/client/deployments'
                command_options = { verbose: options.verbose, output: options.output }
                result = PactBroker::Client::Deployments.const_get(command_class_name).call(params, command_options, pact_broker_client_options)
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
