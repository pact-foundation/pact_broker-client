require 'pact_broker/client/can_i_deploy'
require 'pact_broker/client/version'
require 'pact_broker/client/cli/version_selector_options_parser'
require 'pact_broker/client/cli/custom_thor'
require 'pact_broker/client/publish_pacts'
require 'rake/file_list'

module PactBroker
  module Client
    module CLI
      # Thor::Error will have its backtrace hidden
      class PactPublicationError < ::Thor::Error; end

      class Broker < CustomThor
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

        desc 'publish PACT_DIRS_OR_FILES ...', "Publish pacts to a Pact Broker."
        method_option :consumer_app_version, required: true, aliases: "-a", desc: "The consumer application version"
        method_option :broker_base_url, required: true, aliases: "-b", desc: "The base URL of the Pact Broker"
        method_option :broker_username, aliases: "-u", desc: "Pact Broker basic auth username"
        method_option :broker_password, aliases: "-p", desc: "Pact Broker basic auth password"
        method_option :tag, aliases: "-t", type: :array, banner: "TAG", desc: "Tag name for consumer version. Can be specified multiple times."
        method_option :verbose, aliases: "-v", desc: "Verbose output", :required => false

        def publish(*pact_files)
          validate_pact_files(pact_files)
          success = publish_pacts(pact_files)
          raise PactPublicationError, "One or more pacts failed to be published" unless success
        rescue PactBroker::Client::Error => e
          raise PactPublicationError, "#{e.class} - #{e.message}"
        end

        desc 'version', "Show the pact_broker-client gem version"
        def version
          $stdout.puts PactBroker::Client::VERSION
        end

        no_commands do

          def self.exit_on_failure?
            true
          end

          def validate_pact_files pact_files
            unless pact_files && pact_files.any?
              raise RequiredArgumentMissingError, "No value provided for required pact_files"
            end
          end

          def publish_pacts pact_files
            PactBroker::Client::PublishPacts.call(
              options.broker_base_url,
              file_list(pact_files),
              options.consumer_app_version,
              tags,
              pact_broker_client_options
            )
          end

          def file_list pact_files
            Rake::FileList[pact_files].collect do | path |
              if File.directory?(path)
                Rake::FileList[File.join(path, "*.json")]
              else
                path
              end
            end.flatten
          end

          def tags
            [*options.tag].compact
          end

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
