require 'pact_broker/client/hal_client_methods'
require 'pact_broker/client/error'
require 'pact_broker/client/command_result'
require 'term/ansicolor'
require 'pact_broker/client/backports'

module PactBroker
  module Client
    class BaseCommand
      include PactBroker::Client::HalClientMethods

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
          red(e.message)
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

      def error_message_as_json(message)
        { error: { message: message } }.to_json
      end

      def text_error_message(e, include_backtrace)
        maybe_backtrace = (include_backtrace ? "\n" + e.backtrace.join("\n") : "")
        exception_message = e.is_a?(PactBroker::Client::Error) ? e.message : "#{e.class} - #{e.message}"
        red(exception_message) + maybe_backtrace
      end

      def check_if_command_supported
      end

      def json_output?
        options[:output] == "json"
      end

      def verbose?
        options[:verbose]
      end

      def green(text)
        ::Term::ANSIColor.green(text)
      end

      def red(text)
        ::Term::ANSIColor.red(text)
      end
    end
  end
end
