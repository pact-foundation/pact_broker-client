require 'pact_broker/client/base_command'

module PactBroker
  module Client
    module Deployments
      class RecordUndeployment < PactBroker::Client::BaseCommand
        def initialize(params, options, pact_broker_client_options)
          super
          @pacticipant_name = params.fetch(:pacticipant_name)
          @environment_name = params.fetch(:environment_name)
          @target = params.fetch(:target)
        end

        private

        def do_call
          if undeployed_versions_resources.empty?
            check_pacticipant_exists!
            PactBroker::Client::CommandResult.new(false, deployed_version_not_found_error_message)
          else
            PactBroker::Client::CommandResult.new(undeployed_versions_resources.all?(&:success?), result_message)
          end
        end

        attr_reader :pacticipant_name, :environment_name, :target

        def currently_deployed_versions_link
          environment_resource._link("pb:currently-deployed-versions") or raise PactBroker::Client::Error.new(not_supported_message)
        end

        def currently_deployed_versions_resource
          @deployed_version_links ||= currently_deployed_versions_link.get!(pacticipant: pacticipant_name, target: target)
        end

        def undeployed_versions_resources
          @undeployed_versions_resources ||= currently_deployed_versions_resource.embedded_entities!("deployedVersions").collect do | entity |
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

        def check_pacticipant_exists!
          if index_resource._link!("pb:pacticipant").expand(pacticipant: pacticipant_name).get.does_not_exist?
            raise PactBroker::Client::Error.new("No pacticipant with name '#{pacticipant_name}' found")
          end
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
          message = "#{message} (target #{target})" if target
          message
        end

        def deployed_version_not_found_error_message
          target_bit = target ? " with target '#{target}'" : ""
          message = "#{pacticipant_name} is not currently deployed to #{environment_name}#{target_bit}. Cannot record undeployment."

          if json_output?
            { error: message }.to_json
          else
            red(message)
          end
        end

        def not_supported_message
          "This version of the Pact Broker does not support recording undeployments. Please upgrade to version 2.80.0 or later."
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
