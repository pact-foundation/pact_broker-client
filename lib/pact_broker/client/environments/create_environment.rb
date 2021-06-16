require 'pact_broker/client/environments/environment_command'

module PactBroker
  module Client
    module Environments
      class CreateEnvironment < PactBroker::Client::Environments::EnvironmentCommand

        private

        attr_reader :created_environment_resource

        def do_call
          @created_environment_resource = environments_link.post!(new_environment_body)
          PactBroker::Client::CommandResult.new(created_environment_resource.success?, result_message)
        end

        def result_message
          if json_output?
            created_environment_resource.response.raw_body
          else
            ::Term::ANSIColor.green("Created #{params[:name]} environment in #{pact_broker_name} with UUID #{uuid}")
          end
        end

        def uuid
          created_environment_resource.uuid
        end
      end
    end
  end
end
