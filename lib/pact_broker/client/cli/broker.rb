require 'pact_broker/client/cli/custom_thor'
require 'pact_broker/client/hash_refinements'
require 'thor/error'
require 'pact_broker/client/cli/environment_commands'
require 'pact_broker/client/cli/deployment_commands'
require 'pact_broker/client/cli/pacticipant_commands'
require 'pact_broker/client/cli/webhook_commands'

module PactBroker
  module Client
    module CLI
      # Thor::Error will have its backtrace hidden
      class PactPublicationError < ::Thor::Error; end
      class AuthError < ::Thor::Error; end
      class VersionCreationError < ::Thor::Error; end

      class Broker < CustomThor
        using PactBroker::Client::HashRefinements

        include PactBroker::Client::CLI::EnvironmentCommands
        include PactBroker::Client::CLI::DeploymentCommands
        include PactBroker::Client::CLI::PacticipantCommands
        include PactBroker::Client::CLI::WebhookCommands

        desc 'can-i-deploy', ''
        long_desc File.read(File.join(__dir__, 'can_i_deploy_long_desc.txt'))

        method_option :pacticipant, required: true, aliases: "-a", desc: "The pacticipant name. Use once for each pacticipant being checked."
        method_option :version, required: false, aliases: "-e", desc: "The pacticipant version. Must be entered after the --pacticipant that it relates to."
        method_option :ignore, required: false, desc: "The pacticipant name to ignore. Use once for each pacticipant being ignored. A specific version can be ignored by also specifying a --version after the pacticipant name option."
        method_option :latest, required: false, aliases: "-l", banner: '[TAG]', desc: "Use the latest pacticipant version. Optionally specify a TAG to use the latest version with the specified tag."
        method_option :to, required: false, banner: 'TAG', desc: "This is too hard to explain in a short sentence. Look at the examples.", default: nil
        method_option :to_environment, required: false, banner: 'ENVIRONMENT', desc: "The environment into which the pacticipant(s) are to be deployed", default: nil, hide: true
        method_option :output, aliases: "-o", desc: "json or table", default: 'table'
        method_option :retry_while_unknown, banner: 'TIMES', type: :numeric, default: 0, required: false, desc: "The number of times to retry while there is an unknown verification result (ie. the provider verification is likely still running)"
        method_option :retry_interval, banner: 'SECONDS', type: :numeric, default: 10, required: false, desc: "The time between retries in seconds. Use in conjuction with --retry-while-unknown"
        # Allow limit to be set manually until https://github.com/pact-foundation/pact_broker-client/issues/53 is fixed
        method_option :limit, hide: true
        method_option :dry_run, type: :boolean, default: false, desc: "When dry-run is enabled, always exit process with a success code. Can also be enabled by setting the environment variable PACT_BROKER_CAN_I_DEPLOY_DRY_RUN=true."
        shared_authentication_options

        def can_i_deploy(*ignored_but_necessary)
          require 'pact_broker/client/cli/version_selector_options_parser'
          require 'pact_broker/client/can_i_deploy'

          validate_credentials
          selectors = VersionSelectorOptionsParser.call(ARGV).select { |s| !s[:ignore] }
          ignore_selectors = if ENV.fetch("PACT_BROKER_FEATURES", "").include?("ignore")
            VersionSelectorOptionsParser.call(ARGV).select { |s| s[:ignore] }
          else
            []
          end
          validate_can_i_deploy_selectors(selectors)
          dry_run = options.dry_run || ENV["PACT_BROKER_CAN_I_DEPLOY_DRY_RUN"] == "true"
          can_i_deploy_options = { output: options.output, retry_while_unknown: options.retry_while_unknown, retry_interval: options.retry_interval, dry_run: dry_run }
          result = CanIDeploy.call(options.broker_base_url, selectors, { to_tag: options.to, to_environment: options.to_environment, limit: options.limit, ignore_selectors: ignore_selectors }, can_i_deploy_options, pact_broker_client_options)
          $stdout.puts result.message
          $stdout.flush
          exit(can_i_deploy_exit_status) unless result.success
        end

        desc 'publish PACT_DIRS_OR_FILES ...', "Publish pacts to a Pact Broker."
        method_option :consumer_app_version, required: true, aliases: "-a", desc: "The consumer application version"
        method_option :branch, aliases: "-h", desc: "Repository branch of the consumer version"
        method_option :auto_detect_version_properties, hidden: true, type: :boolean, default: false, desc: "Automatically detect the repository branch from known CI environment variables or git CLI."
        method_option :tag, aliases: "-t", type: :array, banner: "TAG", desc: "Tag name for consumer version. Can be specified multiple times."
        method_option :tag_with_git_branch, aliases: "-g", type: :boolean, default: false, required: false, desc: "Tag consumer version with the name of the current git branch. Default: false"
        method_option :build_url, desc: "The build URL that created the pact"
        method_option :merge, type: :boolean, default: false, require: false, desc: "If a pact already exists for this consumer version and provider, merge the contents. Useful when running Pact tests concurrently on different build nodes."
        output_option_json_or_text
        shared_authentication_options

        def publish(*pact_files)
          require 'pact_broker/client/error'
          validate_credentials
          validate_pact_files(pact_files)
          result = publish_pacts(pact_files)
          $stdout.puts result.message
          exit(1) unless result.success
        rescue PactBroker::Client::Error => e
          raise PactPublicationError, "#{e.class} - #{e.message}"
        end

        desc 'create-version-tag', 'Add a tag to a pacticipant version'
        method_option :pacticipant, required: true, aliases: "-a", desc: "The pacticipant name"
        method_option :version, required: true, aliases: "-e", desc: "The pacticipant version"
        method_option :tag, aliases: "-t", type: :array, banner: "TAG", desc: "Tag name for pacticipant version. Can be specified multiple times."
        method_option :auto_create_version, type: :boolean, default: false, desc: "Automatically create the pacticipant version if it does not exist. Default: false"
        method_option :tag_with_git_branch, aliases: "-g", type: :boolean, default: false, required: false, desc: "Tag pacticipant version with the name of the current git branch. Default: false"
        shared_authentication_options

        def create_version_tag
          require 'pact_broker/client/create_tag'

          validate_credentials
          PactBroker::Client::CreateTag.call(
            options.broker_base_url,
            options.pacticipant,
            options.version,
            tags,
            options.auto_create_version,
            pact_broker_client_options)
        rescue PactBroker::Client::Error => e
          raise VersionCreationError.new(e.message)
        end

        method_option :pacticipant, required: true, aliases: "-a", desc: "The name of the pacticipant that the version belongs to."
        method_option :version, required: false, aliases: "-e", desc: "The pacticipant version number."
        method_option :latest, required: false, aliases: "-l", banner: '[TAG]', desc: "Describe the latest pacticipant version. Optionally specify a TAG to describe the latest version with the specified tag."
        method_option :output, aliases: "-o", desc: "json or table or id", default: 'table'
        shared_authentication_options

        desc 'describe-version', 'Describes a pacticipant version. If no version or tag is specified, the latest version is described.'
        def describe_version
          require 'pact_broker/client/versions/describe'

          validate_credentials
          latest = !options.latest.nil? || (options.latest.nil? && options.version.nil?)
          params = {
            pacticipant: options.pacticipant,
            version: options.version,
            latest: latest,
            tag: options.latest != "latest" ? options.latest : nil
          }
          opts = {
            output: options.output
          }
          result = PactBroker::Client::Versions::Describe.call(params, opts, options.broker_base_url, pact_broker_client_options)
          $stdout.puts result.message
          exit(1) unless result.success
        end



        ignored_and_hidden_potential_options_from_environment_variables
        desc 'generate-uuid', 'Generate a UUID for use when calling create-or-update-webhook'
        def generate_uuid
          require 'securerandom'

          puts SecureRandom.uuid
        end

        desc 'list-latest-pact-versions', 'List the latest pact for each integration'
        shared_authentication_options
        output_option_json_or_table
        def list_latest_pact_versions(*required_but_ignored)
          require 'pact_broker/client/pacts/list_latest_versions'
          result = PactBroker::Client::Pacts::ListLatestVersions.call(options.broker_base_url, options.output, pact_broker_client_options)
          $stdout.puts result.message
          exit(1) unless result.success
        end

        ignored_and_hidden_potential_options_from_environment_variables
        desc 'version', "Show the pact_broker-client gem version"
        def version
          require 'pact_broker/client/version'

          $stdout.puts PactBroker::Client::VERSION
        end

        no_commands do

          def self.exit_on_failure?
            true
          end

          def can_i_deploy_exit_status
            exit_code_string = ENV.fetch('PACT_BROKER_CAN_I_DEPLOY_EXIT_CODE_BETA', '')
            if exit_code_string =~ /^\d+$/
              $stderr.puts "Exiting can-i-deploy with configured exit code #{exit_code_string}"
              exit_code_string.to_i
            else
              1
            end
          end

          def validate_credentials
            if options.broker_username && options.broker_token
              raise AuthError, "You cannot provide both a username/password and a bearer token. If your Pact Broker uses a bearer token, please remove the username and password configuration."
            end
          end

          def validate_pact_files pact_files
            unless pact_files && pact_files.any?
              raise ::Thor::RequiredArgumentMissingError, "No value provided for required pact_files"
            end
          end

          def validate_can_i_deploy_selectors selectors
            pacticipants_without_versions = selectors.select{ |s| s[:version].nil? && s[:latest].nil? && s[:tag].nil? }.collect{ |s| s[:pacticipant] }
            raise ::Thor::RequiredArgumentMissingError, "The version must be specified using `--version VERSION`, `--latest`, `--latest TAG`, or `--all TAG` for pacticipant #{pacticipants_without_versions.join(", ")}" if pacticipants_without_versions.any?
          end

          def publish_pacts pact_files
            require 'pact_broker/client/publish_pacts'

            write_options = options[:merge] ? { write: :merge } : {}
            consumer_version_params = {
              number: options.consumer_app_version,
              branch: branch,
              tags: tags,
              build_url: options.build_url,
              version_required: (!!options.branch || !!options.build_url || explict_auto_detect_version_properties)
            }.compact

            PactBroker::Client::PublishPacts.call(
              options.broker_base_url,
              file_list(pact_files),
              consumer_version_params,
              { merge: options[:merge], output: options.output }.compact,
              pact_broker_client_options.merge(write_options)
            )
          end

          def file_list pact_files
            require 'rake/file_list'

            correctly_separated_pact_files = pact_files.collect{ |path| path.gsub(/\\+/, '/') }
            paths = Rake::FileList[correctly_separated_pact_files].collect do | path |
              if File.directory?(path)
                Rake::FileList[File.join(path, "*.json")]
              else
                path
              end
            end.flatten
            validate_pact_path_list(paths)
          end

          def validate_pact_path_list(paths)
            paths.collect do | path |
              if File.exist?(path)
                path
              elsif path.start_with?("-")
                raise Thor::Error.new("ERROR: pact-broker publish was called with invalid arguments #{[path]}")
              else
                raise Thor::Error.new("Specified pact file '#{path}' does not exist. This sometimes indicates one of the arguments has been specified with the wrong name and has been incorrectly identified as a file path.")
              end
            end
          end

          def tags
            require 'pact_broker/client/git'

            t = [*options.tag]
            t << PactBroker::Client::Git.branch(raise_error: true) if options.tag_with_git_branch
            t.compact.uniq
          end

          def branch
            require 'pact_broker/client/git'

            if options.branch.nil? && options.auto_detect_version_properties
              PactBroker::Client::Git.branch(raise_error: explict_auto_detect_version_properties)
            else
              options.branch
            end
          end

          def explict_auto_detect_version_properties
            @explict_auto_detect_version_properties ||= ARGV.include?("--auto-detect-version-properties")
          end

          def pact_broker_client_options
            client_options = { verbose: options.verbose, pact_broker_base_url: options.broker_base_url }
            client_options[:token] = options.broker_token || ENV['PACT_BROKER_TOKEN']
            if options.broker_username || ENV['PACT_BROKER_USERNAME']
              client_options[:basic_auth] = {
                  username: options.broker_username || ENV['PACT_BROKER_USERNAME'],
                  password: options.broker_password || ENV['PACT_BROKER_PASSWORD']
                }.compact
            end

            client_options.compact
          end
        end
      end
    end
  end
end
