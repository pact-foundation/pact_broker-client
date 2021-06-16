# Need Versions class to extend BaseClient until we can remove the old Versions code
require 'pact_broker/client/base_client'
require 'pact_broker/client/pact_broker_client'
require 'pact_broker/client/versions/formatter'

module PactBroker
  module Client
    class Versions < BaseClient
      class Describe

        class Result
          attr_reader :success, :message

          def initialize success, message = nil
            @success = success
            @message = message
          end
        end

        def self.call params, options, pact_broker_base_url, pact_broker_client_options
          new(params, options, pact_broker_base_url, pact_broker_client_options).call
        end

        def initialize params, options, pact_broker_base_url, pact_broker_client_options
          @params = params
          @options = options
          @pact_broker_base_url = pact_broker_base_url
          @pact_broker_client_options = pact_broker_client_options
        end

        def call
          version_hash = if params[:version]
            versions_client.find(params)
          else
            pact_broker_client.pacticipants.versions.latest(params)
          end
          if version_hash
            Result.new(true, format_version(version_hash))
          else
            Result.new(false, "Pacticipant version not found")
          end
        end

        private

        def format_version(version_hash)
          Formatter.call(version_hash, options[:output])
        end

        attr_reader :params, :options, :pact_broker_base_url, :pact_broker_client_options

        def versions_client
          pact_broker_client.pacticipants.versions
        end

        def pact_broker_client
          @pact_broker_client ||= PactBroker::Client::PactBrokerClient.new(base_url: pact_broker_base_url, client_options: pact_broker_client_options)
        end
      end
    end
  end
end
