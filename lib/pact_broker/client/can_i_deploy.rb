require 'pact_broker/client/error'
require 'pact_broker/client/pact_broker_client'
require 'pact_broker/client/retry'
require 'pact_broker/client/matrix_text_formatter'


module PactBroker
  module Client
    class CanIDeploy

      class Result
        attr_reader :success, :message

        def initialize success, message = nil
          @success = success
          @message = message
        end
      end

      def self.call(pact_broker_base_url, version_selectors, pact_broker_client_options={})
        new(pact_broker_base_url, version_selectors, pact_broker_client_options).call
      end

      def initialize(pact_broker_base_url, version_selectors, pact_broker_client_options)
        @pact_broker_base_url = pact_broker_base_url
        @version_selectors = version_selectors
        @pact_broker_client_options = pact_broker_client_options
      end

      def call
        if matrix.any?
          Result.new(true, success_message(matrix))
        else
          Result.new(false, 'Computer says no ¯\_(ツ)_/¯')
        end
      rescue PactBroker::Client::Error => e
        Result.new(false, e.message)
      rescue StandardError => e
        Result.new(false, "Error retrieving matrix. #{e.class} - #{e.message}\n#{e.backtrace.join("\n")}")
      end

      private

      attr_reader :pact_broker_base_url, :version_selectors, :pact_broker_client_options

      def success_message matrix
        'Computer says yes \o/' + "\n\n" + MatrixTextFormatter.call(matrix)
      end

      def matrix
        @matrix ||= Retry.until_true { pact_broker_client.matrix.get(version_selectors) }
      end

      def pact_broker_client
        @pact_broker_client ||= PactBroker::Client::PactBrokerClient.new(base_url: pact_broker_base_url, client_options: pact_broker_client_options)
      end
    end
  end
end
