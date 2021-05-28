require 'pact_broker/client/environments/environment_command'
require 'pact_broker/client/generate_display_name'
require 'yaml'

module PactBroker
  module Client
    module Environments
      class DescribeEnvironment < PactBroker::Client::Environments::EnvironmentCommand
        include PactBroker::Client::GenerateDisplayName
        private

        def do_call
          existing_environment_resource!
          PactBroker::Client::CommandResult.new(true, result_message)
        end

        def result_message
          if json_output?
            existing_environment_resource.response.raw_body
          else
            YAML.dump(displayify_keys(existing_environment_resource.response.body.except("_links"))).gsub("---\n", "")
          end
        end

        def displayify_keys(thing)
          case thing
          when Hash then thing.each_with_object({}) { | (key, value), new_hash | new_hash[generate_display_name(key)] = displayify_keys(value) }
          when Array then thing.collect{ | value | displayify_keys(value) }
          else
            thing
          end
        end
      end
    end
  end
end
