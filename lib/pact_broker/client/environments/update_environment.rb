require 'pact_broker/client/environments/environment_command'

module PactBroker
  module Client
    module Environments
      class UpdateEnvironment < PactBroker::Client::Environments::EnvironmentCommand

        private

        attr_reader :updated_environment_resource

        def do_call
          @updated_environment_resource = existing_environment_link.put!(request_body)
          PactBroker::Client::CommandResult.new(updated_environment_resource.success?, result_message)
        end

        def request_body
          @request_body ||= existing_environment_body.merge(new_environment_body)
        end

        def result_message
          if json_output?
            updated_environment_resource.response.raw_body
          else
            ::Term::ANSIColor.green("Updated #{request_body["name"]} environment in #{pact_broker_name}")
          end
        end
      end
    end
  end
end
