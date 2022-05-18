require 'pact_broker/client/base_command'

module PactBroker
  module Client
    module Deployments
      class RecordRelease < PactBroker::Client::BaseCommand
        def initialize(params, options, pact_broker_client_options)
          super
          @pacticipant_name = params.fetch(:pacticipant_name)
          @version_number = params.fetch(:version_number)
          @environment_name = params.fetch(:environment_name)
        end

        private

        attr_reader :pacticipant_name, :version_number, :environment_name
        attr_reader :deployed_version_resource

        def do_call
          record_action
          PactBroker::Client::CommandResult.new(true, result_message)
        end

        def action
          "release"
        end

        def action_relation_name
          "pb:record-release"
        end

        def not_supported_message
          if is_pactflow?
            "This version of Pactflow does not support recording #{action}s, or you do not have the required permission to read environments. Please upgrade to the latest version if using Pactflow On-Premises, and ensure the user has the environment read permission."
          else
            "This version of the Pact Broker does not support recording #{action}s. Please upgrade to version 2.80.0 or later."
          end
        end

        def environment_exists?
          index_resource
            ._link!("pb:environments")
            .get!
            ._links("pb:environments")
            .find(environment_name)
        end

        def record_action
          @deployed_version_resource =
            get_record_action_relation
            .post(record_action_request_body)
            .assert_success!
        end

        def record_action_links
          get_pacticipant_version._links(action_relation_name) or raise PactBroker::Client::Error.new(not_supported_message)
        end

        def get_record_action_relation
          record_action_links.find(environment_name) or record_action_links.find!(environment_name, environment_relation_not_found_error_message)
        end

        def environment_relation_not_found_error_message
          if environment_exists?
            "Environment '#{environment_name}' is not an available option for recording a deployment of #{pacticipant_name}."
          else
            if is_pactflow?
              "Environment '#{environment_name}' is not an available option for recording a deployment of #{pacticipant_name}. The environment may not exist, or you may not have the required permissions or team associations to view it."
            else
              "No environment found with name '#{environment_name}'."
            end
          end
        end

        def get_pacticipant_version
          index_resource
            ._link!("pb:pacticipant-version")
            .expand(pacticipant: pacticipant_name, version: version_number)
            .get
            .assert_success!(404 => "#{pacticipant_name} version #{version_number} not found")
        end

        def record_action_request_body
          {}
        end

        def result_message
          if json_output?
            deployed_version_resource.response.raw_body
          else
            green("#{result_text_message} in #{pact_broker_name}.")
          end
        end

        def result_text_message
          "Recorded #{action} of #{pacticipant_name} version #{version_number} to #{environment_name} environment"
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
