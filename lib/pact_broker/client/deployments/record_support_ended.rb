require 'pact_broker/client/base_command'

module PactBroker
  module Client
    module Deployments
      class RecordSupportEnded < PactBroker::Client::BaseCommand
        def initialize(params, options, pact_broker_client_options)
          super
          @pacticipant_name = params.fetch(:pacticipant_name)
          @environment_name = params.fetch(:environment_name)
          @version_number = params.fetch(:version_number)
        end

        private

        def do_call
          if unsupported_versions_resources.empty?
            PactBroker::Client::CommandResult.new(false, error_result_message)
          else
            PactBroker::Client::CommandResult.new(unsupported_versions_resources.all?(&:success?), result_message)
          end
        end

        attr_reader :pacticipant_name, :environment_name, :version_number

        def currently_supported_versions_link
          environment_resource._link("pb:currently-supported-released-versions", "pb:currently-supported-versions") or raise PactBroker::Client::Error.new(not_supported_message)
        end

        def currently_supported_version_entities_for_pacticipant_version
          @deployed_version_links ||= currently_supported_versions_link.get!(pacticipant: pacticipant_name, version: version_number).embedded_entities!("releasedVersions")
        end

        def unsupported_versions_resources
          @unsupported_versions_resources ||= currently_supported_version_entities_for_pacticipant_version.collect do | entity |
            entity._link!("self").patch(currentlySupported: false)
          end
        end

        def action
          "undeployment"
        end

        def environment_resource
          index_resource
            ._link!("pb:environments")
            .get!
            ._links("pb:environments")
            .find!(environment_name, "No environment found with name '#{environment_name}'")
            .get!
        end

        def result_message
          if json_output?
            unsupported_versions_resources.collect{ | resource | resource.response.body }.to_a.to_json
          else
            unsupported_versions_resources.collect do | undeployed_versions_resource |
              if undeployed_versions_resource.success?
                green("#{success_result_text_message(undeployed_versions_resource)} in #{pact_broker_name}.")
              else
                red(undeployed_versions_resource.error_message)
              end
            end.join("\n")
          end
        end

        def success_result_text_message(undeployed_versions_resource)
          "Recorded support ended for #{pacticipant_name} version #{version_number} in #{environment_name} environment"
        end

        def error_result_message
          if json_output?
            error_message_as_json(error_text)
          else
            red(error_text)
          end
        end

        def error_text
          if pacticipant_does_not_exist?
            "No pacticipant with name '#{pacticipant_name}' found."
          else
            "#{pacticipant_name} version #{version_number} is not currently released in #{environment_name} environment. Cannot record support ended."
          end
        end

        def not_supported_message
          "This version of the Pact Broker does not support recording end of support. Please upgrade to version 2.80.0 or later."
        end

        def pacticipant_does_not_exist?
          index_resource._link("pb:pacticipant") && index_resource._link("pb:pacticipant").expand(pacticipant: pacticipant_name).get.does_not_exist?
        end

        def check_if_command_supported
          unless index_resource.can?("pb:environments")
            raise PactBroker::Client::Error.new(not_supported_message)
          end
        end
      end
    end
  end
end
