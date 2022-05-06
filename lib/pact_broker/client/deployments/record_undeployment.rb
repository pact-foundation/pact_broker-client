require 'pact_broker/client/base_command'
require 'pact_broker/client/hash_refinements'

module PactBroker
  module Client
    module Deployments
      class RecordUndeployment < PactBroker::Client::BaseCommand
        using PactBroker::Client::HashRefinements

        def initialize(params, options, pact_broker_client_options)
          super
          @pacticipant_name = params.fetch(:pacticipant_name)
          @environment_name = params.fetch(:environment_name)
          @application_instance = params.fetch(:application_instance)
        end

        private

        def do_call
          if undeployed_versions_resources.empty?
            PactBroker::Client::CommandResult.new(false, error_result_message)
          else
            PactBroker::Client::CommandResult.new(undeployed_versions_resources.all?(&:success?), result_message)
          end
        end

        attr_reader :pacticipant_name, :environment_name, :application_instance

        def currently_deployed_versions_link
          environment_resource._link("pb:currently-deployed-deployed-versions", "pb:currently-deployed-versions") or raise PactBroker::Client::Error.new(not_supported_message)
        end

        def currently_deployed_version_entities_for_pacticipant
          @deployed_version_links ||= currently_deployed_versions_link.get!(pacticipant: pacticipant_name).embedded_entities!("deployedVersions")
        end

        def currently_deployed_version_entities_for_pacticipant_and_instance
          currently_deployed_version_entities_for_pacticipant.select do | entity |
            if application_instance
              entity.applicationInstance == application_instance || entity.target == application_instance
            else
              entity.applicationInstance == nil && entity.target == nil
            end

          end
        end

        def undeployed_versions_resources
          @undeployed_versions_resources ||= currently_deployed_version_entities_for_pacticipant_and_instance.collect do | entity |
            entity._link!("self").patch(currentlyDeployed: false)
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
            undeployed_versions_resources.collect{ | resource | resource.response.body }.to_a.to_json
          else
            undeployed_versions_resources.collect do | undeployed_versions_resource |
              if undeployed_versions_resource.success?
                green("#{success_result_text_message(undeployed_versions_resource)} in #{pact_broker_name}.")
              else
                red(undeployed_versions_resource.error_message)
              end
            end.join("\n")
          end
        end

        def success_result_text_message(undeployed_versions_resource)
          version = undeployed_versions_resource.embedded_entity{ | embedded_entity| embedded_entity && embedded_entity['version'] }
          message = "Recorded #{action} of #{pacticipant_name}"
          message = "#{message} version #{version.number}" if (version && version.number)
          message = "#{message} from #{environment_name} environment"
          message = "#{message} (application instance #{application_instance})" if application_instance
          message
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
            if currently_deployed_version_entities_for_pacticipant.any?
              application_instance_does_not_match_message
            else
              "#{pacticipant_name} is not currently deployed to #{environment_name} environment. Cannot record undeployment."
            end
          end
        end

        def application_instance_does_not_match_message
          potential_application_instances = currently_deployed_version_entities_for_pacticipant.collect{|e| e.applicationInstance || e.target }

          if application_instance
            omit_text = potential_application_instances.include?(nil) ? "omit the application instance" : nil
            specify_text = potential_application_instances.compact.any? ? "specify one of the following application instances to record the undeployment from: #{potential_application_instances.compact.join(", ")}" : nil
            "#{pacticipant_name} is not currently deployed to application instance '#{application_instance}' in #{environment_name} environment. Please #{[omit_text, specify_text].compact.join(" or ")}."
          else
            "Please specify one of the following application instances to record the undeployment from: #{potential_application_instances.compact.join(", ")}"
          end
        end

        def not_supported_message
          "This version of the Pact Broker does not support recording undeployments. Please upgrade to version 2.80.0 or later."
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
