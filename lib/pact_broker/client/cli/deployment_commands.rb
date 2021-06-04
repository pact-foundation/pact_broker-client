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
              require 'pact_broker/client/versions/record_deployment'
              params = {
                pacticipant_name: options.pacticipant,
                version_number: options.version,
                environment_name: options.environment,
                target: options.target,
                output: options.output
              }
              result = PactBroker::Client::Versions::RecordDeployment.call(
                params,
                options.broker_base_url,
                pact_broker_client_options
              )
              $stdout.puts result.message
              exit(1) unless result.success
            end

            ignored_and_hidden_potential_options_from_environment_variables
            desc "record-undeployment", "Record undeployment of (or the end of support for) a pacticipant version from an environment"
            method_option :pacticipant, required: true, aliases: "-a", desc: "The name of the pacticipant that was deployed."
            method_option :version, required: true, aliases: "-e", desc: "The pacticipant version number that was deployed."
            method_option :environment, required: true, desc: "The name of the environment that the pacticipant version was deployed to."
            output_option_json_or_text
            shared_authentication_options

            def record_undeployment
              require 'pact_broker/client/versions/record_undeployment'
              params = {
                pacticipant_name: options.pacticipant,
                version_number: options.version,
                environment_name: options.environment,
                output: options.output
              }
              result = PactBroker::Client::Versions::RecordUndeployment.call(
                params,
                options.broker_base_url,
                pact_broker_client_options
              )
              $stdout.puts result.message
              exit(1) unless result.success
            end
          end
        end
      end
    end
  end
end
