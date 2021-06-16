require 'pact_broker/client/environments/environment_command'
require 'pact_broker/client/environments/text_formatter'

module PactBroker
  module Client
    module Environments
      class ListEnvironments < PactBroker::Client::Environments::EnvironmentCommand
        private

        attr_reader :environments_resource

        def do_call
          PactBroker::Client::CommandResult.new(true, result_message)
        end

        def environments_resource
          @environments_resource = environments_link.get!
        end

        def result_message
          if json_output?
            environments_resource.response.raw_body
          else
            PactBroker::Client::Environments::TextFormatter.call(environments_resource._embedded["environments"])
          end
        end
      end
    end
  end
end
