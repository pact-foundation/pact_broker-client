module PactBroker
  module Client
    module CLI
      module BranchCommands
        def self.included(thor)
          thor.class_eval do
            method_option :pacticipant, required: true, aliases: "-a", desc: "The name of the pacticipant that the branch belongs to."
            method_option :branch, required: true,  desc: "The pacticipant branch name."
            method_option :error_when_not_found, type: :boolean, default: true, desc: "Raise an error if the branch that is to be deleted is not found."
            shared_authentication_options

            desc "delete-branch", "Deletes a pacticipant branch. Does not delete the versions or pacts/verifications associated with the branch, but does make the pacts inaccessible for verification via consumer versions selectors or WIP pacts."

            def delete_branch
              require "pact_broker/client/branches/delete_branch"

              validate_credentials
              params = {
                pacticipant: options.pacticipant,
                branch: options.branch,
                error_when_not_found: options.error_when_not_found
              }

              result = PactBroker::Client::Branches::DeleteBranch.call(params, {}, pact_broker_client_options)
              $stdout.puts result.message
              exit(1) unless result.success
            end

            no_commands do
              def validate_delete_branch_params
                raise ::Thor::RequiredArgumentMissingError, "Pacticipant name cannot be blank" if options.pacticipant.strip.size == 0
                raise ::Thor::RequiredArgumentMissingError, "Pacticipant branch name cannot be blank" if options.branch.strip.size == 0
              end
            end
          end
        end
      end
    end
  end
end
