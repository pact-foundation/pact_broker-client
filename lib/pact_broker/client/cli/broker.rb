require 'pact_broker/client/can_i_deploy'
require 'pact_broker/client/version'
require 'pact_broker/client/cli/version_selector_options_parser'
require 'thor'

module PactBroker
  module Client
    module CLI
      class Broker < Thor
        desc 'can-i-deploy', "Returns exit code 0 or 1, indicating whether or not the specified application versions are compatible."

        method_option :name, required: true, aliases: "-n", desc: "The application name. Use once for each pacticipant being checked."
        method_option :version, required: true, aliases: "-a", desc: "The application version. Must be entered after a --name."
        method_option :broker_base_url, required: true, aliases: "-b", desc: "The base URL of the Pact Broker"
        method_option :broker_username, aliases: "-u", desc: "Pact Broker basic auth username"
        method_option :broker_password, aliases: "-p", desc: "Pact Broker basic auth password"
        method_option :output, aliases: "-o", desc: "json or table", default: 'table'
        method_option :verbose, aliases: "-v", desc: "Verbose output", :required => false

        def can_i_deploy
          selectors = VersionSelectorOptionsParser.call(ARGV)
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
