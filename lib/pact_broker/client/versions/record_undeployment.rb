require 'pact_broker/client/hal_client_methods'
require 'pact_broker/client/error'
require 'pact_broker/client/command_result'

# TODO
# --limit 1
# order by date so that the oldest one gets undeployed first

module PactBroker
  module Client
    class Versions
      class RecordUndeployment
        include PactBroker::Client::HalClientMethods

        NOT_SUPPORTED_MESSAGE = "This version of the Pact Broker does not support recording undeployments. Please upgrade to version 2.80.0 or later."

        def self.call(params, pact_broker_base_url, pact_broker_client_options)
          new(params, pact_broker_base_url, pact_broker_client_options).call
        end

        def initialize(params, pact_broker_base_url, pact_broker_client_options)
          @pact_broker_base_url = pact_broker_base_url
          @pacticipant_name = params.fetch(:pacticipant_name)
          @version_number = params.fetch(:version_number)
          @environment_name = params.fetch(:environment_name)
          @output = params.fetch(:output)
          @pact_broker_client_options = pact_broker_client_options
        end

        def call
          check_if_command_supported
          if deployed_version_links_for_environment.any?
            @undeployment_entities = deployed_version_links_for_environment.collect do | deployed_version_link |
              deployed_version_link.get!._link!("pb:record-undeployment").post!
            end
          else
            check_environment_exists
            raise_not_found_error
          end

          PactBroker::Client::CommandResult.new(true, "foo")
        rescue PactBroker::Client::Error => e
          PactBroker::Client::CommandResult.new(false, e.message)
        end

        private

        attr_reader :pact_broker_base_url, :pact_broker_client_options
        attr_reader :pacticipant_name, :version_number, :environment_name, :replaced_previous_deployed_version, :output
        attr_reader :deployed_version_resource, :undeployment_entities

        def version_resource
          index_resource._link!("pb:pacticipant-version").expand(pacticipant: pacticipant_name, version: version_number).get!
        end

        def deployed_version_links
          @deployed_version_links ||= version_resource._links!("pb:currently-deployed-versions")
        end

        def deployed_version_links_for_environment
          @deployed_version_links_for_environment ||= deployed_version_links.select(environment_name)
        end

        def check_environment_exists
          index_resource
            ._link!("pb:environments")
            .get!
            ._links("pb:environments")
            .find!(environment_name, "No environment found with name '#{environment_name}'")
        end

        def raise_not_found_error
          raise PactBroker::Client::Error.new(deployed_version_not_found_message)
        end

        def deployed_version_not_found_message
          if (env_names = deployed_version_links.names).any?
            "#{pacticipant_name} version #{version_number} is not currently deployed to #{environment_name}. It is currently deployed to: #{env_names.join(", ")}"
          else
            "#{pacticipant_name} version #{version_number} is not currently deployed to any environment."
          end
        end

        def result_message
          if output == "text"
            message = "Recorded undeployment of #{pacticipant_name} version #{version_number} from #{environment_name} in #{pact_broker_name}."
          elsif output == "json"
            undeployment_entities.last.response.raw_body
          else
            ""
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
