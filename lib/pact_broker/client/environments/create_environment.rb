require 'pact_broker/client/hal_client_methods'
require 'pact_broker/client/error'
require 'pact_broker/client/command_result'
require 'term/ansicolor'

module PactBroker
  module Client
    module Environments
      class CreateEnvironment
        include PactBroker::Client::HalClientMethods

        NOT_SUPPORTED_MESSAGE = "This version of the Pact Broker does not support creation of environments. Please upgrade to version 2.80.0 or later."

        def self.call(params, pact_broker_base_url, pact_broker_client_options)
          new(params, pact_broker_base_url, pact_broker_client_options).call
        end

        def initialize(params, pact_broker_base_url, pact_broker_client_options)
          @params = params
          @pact_broker_base_url = pact_broker_base_url
          @pact_broker_client_options = pact_broker_client_options
        end

        def call
          check_if_command_supported
          create_environment
        rescue PactBroker::Client::Error => e
          PactBroker::Client::CommandResult.new(false, ::Term::ANSIColor.red(e.message))
        end

        private

        attr_reader :params
        attr_reader :pact_broker_base_url, :pact_broker_client_options

        def create_environment
          index_resource
            ._link!("pb:environments")
            .post!(request_body)
          PactBroker::Client::CommandResult.new(true, result_message)
        end

        def request_body
          {
            name: params[:name],
            displayName: params[:display_name],
            production: params[:production],
            contacts: contacts
          }.compact
        end

        def contacts
          if params[:contact_name] || params[:contact_email_address]
            contact = {}
            contact[:name] = params[:contact_name] || "unknown"
            if params[:contact_email_address]
              contact[:details] = { emailAddress: params[:contact_email_address] }
            end
            [contact]
          else
            nil
          end
        end

        def result_message
          prod_label = params[:production] ? "production" : "non-production"
          ::Term::ANSIColor.green("Created #{prod_label} environment #{params[:name]} in #{pact_broker_name}")
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