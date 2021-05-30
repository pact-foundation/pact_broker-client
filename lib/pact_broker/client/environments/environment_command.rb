require 'pact_broker/client/hal_client_methods'
require 'pact_broker/client/error'
require 'pact_broker/client/command_result'
require 'term/ansicolor'
require 'pact_broker/client/backports'

module PactBroker
  module Client
    module Environments
      class EnvironmentCommand
        include PactBroker::Client::HalClientMethods

        NOT_SUPPORTED_MESSAGE = "This version of the Pact Broker does not support environments. Please upgrade to version 2.80.0 or later."

        def self.call(params, options, pact_broker_client_options)
          new(params, options, pact_broker_client_options).call
        end

        def initialize(params, options, pact_broker_client_options)
          @params = params
          @options = options
          @pact_broker_base_url = pact_broker_client_options.fetch(:pact_broker_base_url)
          @pact_broker_client_options = pact_broker_client_options
        end

        def call
          check_if_command_supported
          do_call
        rescue PactBroker::Client::Hal::ErrorResponseReturned => e
          handle_http_error(e)
        rescue PactBroker::Client::Error => e
          handle_ruby_error(e)
        rescue StandardError => e
          handle_ruby_error(e, verbose?)
        end

        private

        attr_reader :params, :options
        attr_reader :pact_broker_base_url, :pact_broker_client_options

        def handle_http_error(e)
          message = if json_output?
            body = e.entity.response.raw_body
            (body.nil? || body == "") ? "{}" : body
          else
            ::Term::ANSIColor.red(e.message)
          end
          PactBroker::Client::CommandResult.new(false, message)
        end

        def handle_ruby_error(e, include_backtrace = false)
          PactBroker::Client::CommandResult.new(false,  error_message(e, include_backtrace))
        end

        def error_message(e, include_backtrace)
          if json_output?
            json_error_message(e, include_backtrace)
          else
            text_error_message(e, include_backtrace)
          end
        end

        def json_error_message(e, include_backtrace)
          error_hash = { message: e.message }
          error_hash[:class] = e.class.name unless e.is_a?(PactBroker::Client::Error)
          error_hash[:backtrace] = e.backtrace if include_backtrace
          { error: error_hash }.to_json
        end


        def text_error_message(e, include_backtrace)
          maybe_backtrace = (include_backtrace ? "\n" + e.backtrace.join("\n") : "")
          exception_message = e.is_a?(PactBroker::Client::Error) ? e.message : "#{e.class} - #{e.message}"
          ::Term::ANSIColor.red(exception_message) + maybe_backtrace
        end


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

        def json_output?
          options[:output] == "json"
        end

        def verbose?
          options[:verbose]
        end
      end
    end
  end
end
