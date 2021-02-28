require 'pact_broker/client/hal_client_methods'
require 'pact_broker/client/error'
require 'pact_broker/client/command_result'

module PactBroker
  module Client
    class Versions
      class RecordDeployment
        include PactBroker::Client::HalClientMethods

        NOT_SUPPORTED_MESSAGE = "This version of the Pact Broker does not support recording deployments. Please upgrade to version 2.80.0 or later."

        def self.call(params, pact_broker_base_url, pact_broker_client_options)
          new(params, pact_broker_base_url, pact_broker_client_options).call
        end

        def initialize(params, pact_broker_base_url, pact_broker_client_options)
          @pact_broker_base_url = pact_broker_base_url
          @pacticipant_name = params.fetch(:pacticipant_name)
          @version_number = params.fetch(:version_number)
          @environment_name = params.fetch(:environment_name)
          @replaced_previous_deployed_version = params.fetch(:replaced_previous_deployed_version)
          @output = params.fetch(:output)
          @pact_broker_client_options = pact_broker_client_options
        end

        def call
          check_if_command_supported
          record_deployment

          PactBroker::Client::CommandResult.new(true, result_message)
        rescue PactBroker::Client::Error => e
          PactBroker::Client::CommandResult.new(false, e.message)
        end

        private

        attr_reader :pact_broker_base_url, :pact_broker_client_options
        attr_reader :pacticipant_name, :version_number, :environment_name, :replaced_previous_deployed_version, :output
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
          { replacedPreviousDeployedVersion: replaced_previous_deployed_version }
        end

        def result_message
          if output == "text"
            message = "Recorded deployment of #{pacticipant_name} version #{version_number} to #{environment_name} in #{pact_broker_name}."
            suffix = replaced_previous_deployed_version ? " Marked previous deployed version as undeployed." : ""
            message + suffix
          elsif output == "json"
            deployed_version_resource.response.raw_body
          else
            ""
          end
        end

        def pact_broker_name
          is_pactflow? ? "Pactflow" : "the Pact Broker"
        end

        def is_pactflow?
          deployed_version_resource.response.headers.keys.any?{ | header_name | header_name.downcase.include?("pactflow") }
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
