require 'pact_broker/client/environments/create_environment'
require 'pact_broker/client/backports'

module PactBroker
  module Client
    module Environments
      class UpdateEnvironment < PactBroker::Client::Environments::CreateEnvironment
        def call
          check_if_command_supported
          update_environment
        rescue PactBroker::Client::Error => e
          PactBroker::Client::CommandResult.new(false, ::Term::ANSIColor.red(e.message))
        end

        private

        def update_environment
          index_resource
            ._link!("pb:environment")
            .expand(uuid: params[:uuid])
            .put!(request_body)
          PactBroker::Client::CommandResult.new(true, result_message)
        end

        def request_body
          @request_body ||= begin
            incoming_params = super
            existing_environment_params.merge(incoming_params)
          end
        end

        def existing_environment_params
          @existing_environment_params ||= index_resource
            ._link!("pb:environment")
            .expand(uuid: params[:uuid])
            .get!
            .response
            .body
            .except("_links", "createdAt", "updatedAt")
        end

        def result_message
          ::Term::ANSIColor.green("Updated environment #{request_body["name"]} in #{pact_broker_name}")
        end
      end
    end
  end
end
