require 'pact_broker/client/base_command'

module PactBroker
  module Client
    module Deployments
      class RecordDeployment < PactBroker::Client::BaseCommand

        NOT_SUPPORTED_MESSAGE = "This version of the Pact Broker does not support recording deployments. Please upgrade to version 2.80.0 or later."

        def initialize(params, options, pact_broker_client_options)
          super
          @pacticipant_name = params.fetch(:pacticipant_name)
          @version_number = params.fetch(:version_number)
          @environment_name = params.fetch(:environment_name)
          @target = params.fetch(:target)
        end

        private

        def do_call
          record_deployment
          PactBroker::Client::CommandResult.new(true, result_message)
        end

        attr_reader :pacticipant_name, :version_number, :environment_name, :target, :output
        attr_reader :deployed_version_resource

        def check_environment_exists
          index_resource
            ._link!("pb:environments")
            .get!
            ._links("pb:environments")
            .find!(environment_name, "No environment found with name '#{environment_name}'")
        end

        def record_deployment
          @deployed_version_resource =
            get_record_deployment_relation
            .post(record_deployment_request_body)
            .assert_success!
        end

        def get_record_deployment_relation
          record_deployment_links = get_pacticipant_version._links!("pb:record-deployment")
          link_for_environment = record_deployment_links.find(environment_name)
          if link_for_environment
            link_for_environment
          else
            check_environment_exists
            # Force the exception to be raised
            record_deployment_links.find!(environment_name, "Environment '#{environment_name}' is not an available option for recording a deployment of #{pacticipant_name}.")
          end
        end

        def get_pacticipant_version
          index_resource
            ._link!("pb:pacticipant-version")
            .expand(pacticipant: pacticipant_name, version: version_number)
            .get
            .assert_success!(404 => "#{pacticipant_name} version #{version_number} not found")
        end

        def record_deployment_request_body
          { target: target }
        end

        def result_message
          if json_output?
            deployed_version_resource.response.raw_body
          else
            message = "Recorded deployment of #{pacticipant_name} version #{version_number} to #{environment_name} environment"
            message = "#{message} (target #{target})" if target
            green("#{message} in #{pact_broker_name}.")
          end
        end

        def check_if_command_supported
          unless index_resource.can?("pb:environments")
            raise PactBroker::Client::Error.new(NOT_SUPPORTED_MESSAGE)
          end
        end
      end
    end
  end
end
