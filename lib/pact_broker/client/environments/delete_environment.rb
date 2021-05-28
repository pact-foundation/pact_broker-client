require 'pact_broker/client/environments/environment_command'

module PactBroker
  module Client
    module Environments
      class DeleteEnvironment < PactBroker::Client::Environments::EnvironmentCommand
        private

        attr_reader :deletion_request_resource

        def do_call
          existing_environment_resource!
          @deletion_request_resource = existing_environment_link.delete!
          PactBroker::Client::CommandResult.new(deletion_request_resource.success?, result_message)
        end

        def result_message
          if json_output?
            deletion_request_resource.response.raw_body
          else
            ::Term::ANSIColor.green("Deleted environment #{existing_environment_resource.name} from #{pact_broker_name}")
          end
        end
      end
    end
  end
end
