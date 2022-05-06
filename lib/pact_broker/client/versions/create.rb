require "pact_broker/client/base_client"
require "pact_broker/client/base_command"

module PactBroker
  module Client
    class Versions < BaseClient # need to retire the old base client code
      class Create < PactBroker::Client::BaseCommand

        def do_call
          if branch_name
            if branch_versions_supported?
              create_branch_version
            else
              raise PactBroker::Client::Error.new("This version of #{pact_broker_name} does not support branch versions,or you do not have the required permissions to create one. Please ensure you have upgraded to version 2.82.0 or later for branch support.")
            end
          end

          if tags
            create_version_tags
          end

          if !branch_name && !tags.any?
            create_version
          end

          PactBroker::Client::CommandResult.new(true, result_message)
        end

        private

        def pacticipant_name
          params.fetch(:pacticipant_name)
        end

        def version_number
          params.fetch(:version_number)
        end

        def branch_name
          params[:branch_name]
        end

        def tags
          params[:tags] || []
        end

        def branch_versions_supported?
          index_resource._link("pb:pacticipant-branch-version")
        end

        def create_branch_version
          branch_params = {
            "pacticipant" => pacticipant_name,
            "version" => version_number,
            "branch" => branch_name
          }
          branch_version_entity = index_resource
                                ._link("pb:pacticipant-branch-version")
                                .expand(branch_params)
                                .put!
        end

        def create_version_tags
          tags.each do | tag |
            tag_params = {
              "pacticipant" => pacticipant_name,
              "version" => version_number,
              "tag" => tag
            }
            index_resource
              ._link("pb:pacticipant-version-tag")
              .expand(tag_params)
              .put!
          end
        end

        def create_version
          @version_resource ||= expanded_version_relation.put!
        end

        def expanded_version_relation
          version_params = {
            "pacticipant" => pacticipant_name,
            "version" => version_number
          }
          index_resource
            ._link("pb:pacticipant-version")
            .expand(version_params)
        end

        def result_message
          if json_output?
            (@version_resource || expanded_version_relation.get).response.raw_body
          else
            message = "Created/updated pacticipant version #{version_number}"
            if branch_name && tags.any?
              message = message + " with branch #{branch_name} and tag(s) #{tags.join(", ")}"
            elsif branch_name
              message = message + " with branch #{branch_name}"
            elsif tags.any?
              message = message + " with tag(s) #{tags.join(", ")}"
            end

            message = message + " in #{pact_broker_name}"
            green(message)
          end
        end
      end
    end
  end
end
