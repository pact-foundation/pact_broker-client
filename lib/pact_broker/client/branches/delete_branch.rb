require "pact_broker/client/base_command"

module PactBroker
  module Client
    module Branches
      class DeleteBranch < PactBroker::Client::BaseCommand

        NOT_SUPPORTED_MESSAGE_PACT_BROKER = "This version of the Pact Broker does not support deleting branches. Please upgrade to version 2.108.0 or later."
        NOT_SUPPORTED_MESSAGE_PACTFLOW = "This version of PactFlow does not support deleting branches. Please upgrade to the latest version."

        def initialize(params, options, pact_broker_client_options)
        	super
          @pacticipant_name = params.fetch(:pacticipant)
        	@branch_name = params.fetch(:branch)
          @error_when_not_found = params.fetch(:error_when_not_found)
        end

				def do_call
					check_if_command_supported
          @deleted_resource = branch_link.delete
          PactBroker::Client::CommandResult.new(success?, result_message)
        end

        private

        attr_reader :pacticipant_name, :branch_name, :error_when_not_found, :deleted_resource

        def branch_link
          index_resource._link("pb:pacticipant-branch").expand(pacticipant: pacticipant_name, branch: branch_name)
        end

        def check_if_command_supported
          unless index_resource.can?("pb:pacticipant-branch")
          	raise PactBroker::Client::Error.new(is_pactflow? ? NOT_SUPPORTED_MESSAGE_PACTFLOW : NOT_SUPPORTED_MESSAGE_PACT_BROKER)
          end
        end

        def success?
          if deleted_resource.success?
            true
          elsif deleted_resource.response.status == 404 && !error_when_not_found
            true
          else
            false
          end
        end

        def result_message
          if deleted_resource.success?
					 green("Successfully deleted branch #{branch_name} of pacticipant #{pacticipant_name}")
          elsif deleted_resource.response.status == 404
            if error_when_not_found
              red("Could not delete branch #{branch_name} of pacticipant #{pacticipant_name} as it was not found")
            else
              green("Branch #{branch_name} of pacticipant #{pacticipant_name} not found")
            end
          else
            red(deleted_resource.response.raw_body)
          end
        end
      end
    end
  end
end
