require 'pact_broker/client/hal'
require 'json'
require 'pact_broker/client/command_result'
require 'pact_broker/client/hal_client_methods'

module PactBroker
  module Client
    module Pacticipants2
      class Create

        include HalClientMethods

        def self.call(params, pact_broker_base_url, pact_broker_client_options)
          new(params, pact_broker_base_url, pact_broker_client_options).call
        end

        def initialize(params, pact_broker_base_url, pact_broker_client_options)
          @params = params
          @index_entry_point = create_index_entry_point(pact_broker_base_url, pact_broker_client_options)
          @verbose = pact_broker_client_options[:verbose]
        end

        def call
          pacticipant_entity = index_entity._link('pb:pacticipant').expand('pacticipant' => params[:name]).get
          message = nil
          response_entity = if pacticipant_entity.does_not_exist?
            message = "Pacticipant \"#{params[:name]}\" created"
            index_entity._link!('pb:pacticipants').post(pacticipant_resource_params)
          else
            message = "Pacticipant \"#{params[:name]}\" updated"
            pacticipant_entity._link!('self').patch(pacticipant_resource_params)
          end

          response_entity.assert_success!
          PactBroker::Client::CommandResult.new(true, message)
        rescue StandardError => e
          $stderr.puts("#{e.class} - #{e}\n#{e.backtrace.join("\n")}") if verbose
          PactBroker::Client::CommandResult.new(false, "#{e.class} - #{e}")
        end

        private

        attr_reader :index_entry_point, :params, :verbose

        def index_entity
          @index_entity ||= index_entry_point.get!
        end

        def pacticipant_resource_params
          p = { name: params[:name] }
          p[:repositoryUrl] = params[:repository_url] if params[:repository_url]
          p
        end
      end
    end
  end
end
