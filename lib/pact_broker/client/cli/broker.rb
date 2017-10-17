require 'pact_broker/client/can_i_deploy'
require 'pact_broker/client/version'
require 'thor'

module PactBroker
  module Client
    module CLI
      class Broker < Thor
        desc 'can-i-deploy VERSION_SELECTOR_ONE VERSION_SELECTOR_TWO ...', "Returns exit code 0 or 1, indicating whether or not the specified application versions are compatible.\n\nThe VERSION_SELECTOR format is <pacticipant_name>/version/<version_number>."

        method_option :broker_base_url, required: true, aliases: "-b", desc: "The base URL of the Pact Broker"
        method_option :broker_username, aliases: "-n", desc: "Pact Broker basic auth username"
        method_option :broker_password, aliases: "-p", desc: "Pact Broker basic auth password"
        method_option :output, aliases: "-o", desc: "json or table", default: 'table'
        method_option :verbose, aliases: "-v", desc: "Verbose output", :required => false

        def can_i_deploy(*selectors)
          result = CanIDeploy.call(options.broker_base_url, selectors, {output: options.output}, pact_broker_client_options)
          $stdout.puts result.message
          exit(1) unless result.success
        end

        desc 'version', "Show the pact_broker-client gem version"
        def version
          $stdout.puts PactBroker::Client::VERSION
        end

        no_commands do
          def pact_broker_client_options
            if options.broker_username
              {
                basic_auth: {
                  username: options.broker_username,
                  password: options.broker_password
                },
                verbose: options.verbose
              }
            else
              {
                verbose: options.verbose
              }
            end
          end
        end
      end
    end
  end
end
