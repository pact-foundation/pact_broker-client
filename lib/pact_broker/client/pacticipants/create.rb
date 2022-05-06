require 'pact_broker/client/base_command'

module PactBroker
  module Client
    module Pacticipants2
      class Create < PactBroker::Client::BaseCommand

        private

        attr_reader :action, :response_entity

        def do_call
          pacticipant_entity = index_resource._link('pb:pacticipant').expand('pacticipant' => params[:name]).get

          response_entity = if pacticipant_entity.does_not_exist?
            @action = "created"
            index_resource._link!('pb:pacticipants').post!(pacticipant_resource_params)
          elsif pacticipant_entity.success?
            @action = "updated"
            pacticipant_entity._link!('self').patch!(pacticipant_resource_params, { "Content-Type" => "application/json" })
          else
            pacticipant_entity.assert_success!
          end

          response_entity.assert_success!
          PactBroker::Client::CommandResult.new(true, result_message)
        end

        def result_message
          if json_output?
            response_entity.response.raw_body
          else
            green("Pacticipant \"#{params[:name]}\" #{action} in #{pact_broker_name}")
          end
        end

        def pacticipant_resource_params
          {
            name: params[:name],
            repositoryUrl: params[:repository_url],
            displayName: params[:display_name],
            mainBranch: params[:main_branch]
          }.compact
        end
      end
    end
  end
end
