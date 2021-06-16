require 'pact_broker/client/base_command'
require 'pact_broker/client/describe_text_formatter'

module PactBroker
  module Client
    module Pacticipants2
      class Describe < PactBroker::Client::BaseCommand

        private

        def do_call
          PactBroker::Client::CommandResult.new(true, result_message)
        end

        def pacticipant_entity
          @pacticipant_entity ||= index_resource._link('pb:pacticipant').expand('pacticipant' => params[:name]).get!
        end

        def result_message
          if json_output?
            pacticipant_entity.response.raw_body
          else
            properties = pacticipant_entity.response.body.except("_links", "_embedded")
            if pacticipant_entity._embedded && pacticipant_entity._embedded["labels"] && pacticipant_entity._embedded["labels"].any?
              properties["labels"] = pacticipant_entity._embedded["labels"]
            end
            PactBroker::Client::DescribeTextFormatter.call(properties)
          end
        end
      end
    end
  end
end
