require 'pact_broker/client/base_command'
require 'pact_broker/client/pacticipants/text_formatter'

module PactBroker
  module Client
    module Pacticipants2
      class List < PactBroker::Client::BaseCommand
        private

        attr_reader :environments_resource

        def do_call
          PactBroker::Client::CommandResult.new(true, result_message)
        end

        def environments_resource
          @environments_resource = environments_link.get!
        end

        def environments_link
          index_resource._link!('pb:pacticipants')
        end

        def result_message
          if json_output?
            environments_resource.response.raw_body
          else
            TextFormatter.call(environments_resource._embedded["pacticipants"])
          end
        end
      end
    end
  end
end
