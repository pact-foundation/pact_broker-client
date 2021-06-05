require 'pact_broker/client/environments/environment_command'
require 'pact_broker/client/describe_text_formatter'

module PactBroker
  module Client
    module Environments
      class DescribeEnvironment < PactBroker::Client::Environments::EnvironmentCommand
        private

        def do_call
          existing_environment_resource!
          PactBroker::Client::CommandResult.new(true, result_message)
        end

        def result_message
          if json_output?
            existing_environment_resource.response.raw_body
          else
            properties = existing_environment_resource.response.body.except("_links", "_embedded")
            PactBroker::Client::DescribeTextFormatter.call(properties)
          end
        end
      end
    end
  end
end
