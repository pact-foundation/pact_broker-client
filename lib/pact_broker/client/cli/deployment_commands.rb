module PactBroker
  module Client
    module CLI
      module DeploymentCommands
        RECORD_DEPLOYMENT_HELP_URL = "https://docs.pact.io/go/record-deployment"
        RECORD_UNDEPLOYMENT_HELP_URL = "https://docs.pact.io/go/record-undeployment"
        RECORD_RELEASE_HELP_URL = "https://docs.pact.io/go/record-release"
        RECORD_SUPPORT_ENDED_HELP_URL = "https://docs.pact.io/go/record-support-ended"


        def self.included(thor)
          thor.class_eval do
            desc "record-deployment", "Record deployment of a pacticipant version to an environment. See #{RECORD_DEPLOYMENT_HELP_URL} for more information."
            method_option :pacticipant, required: true, aliases: "-a", desc: "The name of the pacticipant that was deployed."
            method_option :version, required: true, aliases: "-e", desc: "The pacticipant version number that was deployed."
            method_option :environment, required: true, desc: "The name of the environment that the pacticipant version was deployed to."
            method_option :application_instance, default: nil, required: false, desc: "Optional. The application instance to which the deployment has occurred - a logical identifer required to differentiate deployments when there are multiple instances of the same application in an environment. This field was called 'target' in a beta release."
            method_option :target, hidden: true, default: nil, required: false, desc: "Renamed to application_instance"
            output_option_json_or_text
            shared_authentication_options

            def record_deployment
              $stderr.puts("WARN: target has been renamed to application-instance") if options.target
              params = {
                pacticipant_name: options.pacticipant,
                version_number: options.version,
                environment_name: options.environment,
                application_instance: options.application_instance || options.target
              }
              execute_deployment_command(params, "RecordDeployment")
            end

            desc "record-undeployment", "Record undeployment of a pacticipant from an environment."
            long_desc "Note that use of this command is only required if you are permanently removing an application instance from an environment. It is not required if you are deploying over a previous version, as record-deployment will automatically mark the previously deployed version as undeployed for you. See #{RECORD_UNDEPLOYMENT_HELP_URL} for more information."
            method_option :pacticipant, required: true, aliases: "-a", desc: "The name of the pacticipant that was undeployed."
            method_option :environment, required: true, desc: "The name of the environment that the pacticipant version was undeployed from."
            method_option :application_instance, default: nil, required: false, desc: "Optional. The application instance from which the application is being undeployed - a logical identifer required to differentiate deployments when there are multiple instances of the same application in an environment. This field was called 'target' in a beta release."
            method_option :target, default: nil, required: false, desc: "Optional. The target that the application is being undeployed from - a logical identifer required to differentiate deployments when there are multiple instances of the same application in an environment."
            output_option_json_or_text
            shared_authentication_options

            def record_undeployment
              $stderr.puts("WARN: target has been renamed to application-instance") if options.target
              params = {
                pacticipant_name: options.pacticipant,
                environment_name: options.environment,
                application_instance: options.application_instance || options.target
              }
              execute_deployment_command(params, "RecordUndeployment")
            end

            desc "record-release", "Record release of a pacticipant version to an environment. See See #{RECORD_RELEASE_HELP_URL} for more information."
            method_option :pacticipant, required: true, aliases: "-a", desc: "The name of the pacticipant that was released."
            method_option :version, required: true, aliases: "-e", desc: "The pacticipant version number that was released."
            method_option :environment, required: true, desc: "The name of the environment that the pacticipant version was released to."
            output_option_json_or_text
            shared_authentication_options

            def record_release
              params = {
                pacticipant_name: options.pacticipant,
                version_number: options.version,
                environment_name: options.environment
              }
              execute_deployment_command(params, "RecordRelease")
            end

            desc "record-support-ended", "Record the end of support for a pacticipant version in an environment. See #{RECORD_SUPPORT_ENDED_HELP_URL} for more information."
            method_option :pacticipant, required: true, aliases: "-a", desc: "The name of the pacticipant."
            method_option :version, required: true, aliases: "-e", desc: "The pacticipant version number for which support is ended."
            method_option :environment, required: true, desc: "The name of the environment in which the support is ended."
            output_option_json_or_text
            shared_authentication_options

            def record_support_ended
              params = {
                pacticipant_name: options.pacticipant,
                version_number: options.version,
                environment_name: options.environment
              }
              execute_deployment_command(params, "RecordSupportEnded")
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
