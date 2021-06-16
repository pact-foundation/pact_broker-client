require 'pact_broker/client/base_command'

module PactBroker
  module Client
    module Environments
      class EnvironmentCommand < PactBroker::Client::BaseCommand
        NOT_SUPPORTED_MESSAGE = "This version of the Pact Broker does not support environments. Please upgrade to version 2.80.0 or later."

        private

        def new_environment_body
          {
            "name" => params[:name],
            "displayName" => params[:display_name],
            "production" => params[:production],
            "contacts" => contacts
          }.compact
        end

        def environments_link
          index_resource._link!("pb:environments")
        end

        def existing_environment_link
          index_resource
            ._link!("pb:environment")
            .expand(uuid: params[:uuid])
        end

        def existing_environment_resource
          @existing_environment_resource ||= existing_environment_link.get
        end

        def existing_environment_resource!
          existing_environment_resource.assert_success!
        end

        def existing_environment_body
          @existing_environment_params ||= existing_environment_resource!
            .response
            .body
            .except("uuid", "_links", "createdAt", "updatedAt")
        end

        def contacts
          if params[:contact_name] || params[:contact_email_address]
            contact = {}
            contact["name"] = params[:contact_name] || "unknown"
            if params[:contact_email_address]
              contact["details"] = { "emailAddress" => params[:contact_email_address] }
            end
            [contact]
          else
            nil
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
