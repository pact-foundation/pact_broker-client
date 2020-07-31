require 'pact_broker/client/cli/custom_thor'
require 'thor/error'

module PactBroker
  module Client
    module CLI
      # Thor::Error will have its backtrace hidden
      class PactPublicationError < ::Thor::Error; end
      class WebhookCreationError < ::Thor::Error; end
      class AuthError < ::Thor::Error; end
      class VersionCreationError < ::Thor::Error; end

      class Broker < CustomThor
        desc 'can-i-deploy', ''
        long_desc File.read(File.join(File.dirname(__FILE__), 'can_i_deploy_long_desc.txt'))

        method_option :pacticipant, required: true, aliases: "-a", desc: "The pacticipant name. Use once for each pacticipant being checked."
        method_option :version, required: false, aliases: "-e", desc: "The pacticipant version. Must be entered after the --pacticipant that it relates to."
        method_option :latest, required: false, aliases: "-l", banner: '[TAG]', desc: "Use the latest pacticipant version. Optionally specify a TAG to use the latest version with the specified tag."
        method_option :to, required: false, banner: 'TAG', desc: "This is too hard to explain in a short sentence. Look at the examples.", default: nil
        method_option :broker_base_url, required: true, aliases: "-b", desc: "The base URL of the Pact Broker"
        method_option :broker_username, aliases: "-u", desc: "Pact Broker basic auth username"
        method_option :broker_password, aliases: "-p", desc: "Pact Broker basic auth password"
        method_option :broker_token, aliases: "-k", desc: "Pact Broker bearer token"
        method_option :output, aliases: "-o", desc: "json or table", default: 'table'
        method_option :verbose, aliases: "-v", type: :boolean, default: false, required: false, desc: "Verbose output. Default: false"
        method_option :retry_while_unknown, banner: 'TIMES', type: :numeric, default: 0, required: false, desc: "The number of times to retry while there is an unknown verification result (ie. the provider verification is likely still running)"
        method_option :retry_interval, banner: 'SECONDS', type: :numeric, default: 10, required: false, desc: "The time between retries in seconds. Use in conjuction with --retry-while-unknown"
        # Allow limit to be set manually until https://github.com/pact-foundation/pact_broker-client/issues/53 is fixed
        method_option :limit, hide: true

        def can_i_deploy(*ignored_but_necessary)
          require 'pact_broker/client/cli/version_selector_options_parser'
          require 'pact_broker/client/can_i_deploy'

          validate_credentials
          selectors = VersionSelectorOptionsParser.call(ARGV)
          validate_can_i_deploy_selectors(selectors)
          can_i_deploy_options = { output: options.output, retry_while_unknown: options.retry_while_unknown, retry_interval: options.retry_interval }
          result = CanIDeploy.call(options.broker_base_url, selectors, {to_tag: options.to, limit: options.limit}, can_i_deploy_options, pact_broker_client_options)
          $stdout.puts result.message
          exit(1) unless result.success
        end

        desc 'publish PACT_DIRS_OR_FILES ...', "Publish pacts to a Pact Broker."
        method_option :consumer_app_version, required: true, aliases: "-a", desc: "The consumer application version"
        method_option :broker_base_url, required: true, aliases: "-b", desc: "The base URL of the Pact Broker"
        method_option :broker_username, aliases: "-u", desc: "Pact Broker basic auth username"
        method_option :broker_password, aliases: "-p", desc: "Pact Broker basic auth password"
        method_option :broker_token, aliases: "-k", desc: "Pact Broker bearer token"
        method_option :tag, aliases: "-t", type: :array, banner: "TAG", desc: "Tag name for consumer version. Can be specified multiple times."
        method_option :tag_with_git_branch, aliases: "-g", type: :boolean, default: false, required: false, desc: "Tag consumer version with the name of the current git branch. Default: false"
        method_option :verbose, aliases: "-v", type: :boolean, default: false, required: false, desc: "Verbose output. Default: false"

        def publish(*pact_files)
          require 'pact_broker/client/error'
          validate_credentials
          validate_pact_files(pact_files)
          success = publish_pacts(pact_files)
          raise PactPublicationError, "One or more pacts failed to be published" unless success
        rescue PactBroker::Client::Error => e
          raise PactPublicationError, "#{e.class} - #{e.message}"
        end

        desc 'create-version-tag', 'Add a tag to a pacticipant version'
        method_option :pacticipant, required: true, aliases: "-a", desc: "The pacticipant name"
        method_option :version, required: true, aliases: "-e", desc: "The pacticipant version"
        method_option :tag, aliases: "-t", type: :array, banner: "TAG", desc: "Tag name for pacticipant version. Can be specified multiple times."
        method_option :auto_create_version, type: :boolean, default: false, desc: "Automatically create the pacticipant version if it does not exist. Default: false"
        method_option :tag_with_git_branch, aliases: "-g", type: :boolean, default: false, required: false, desc: "Tag pacticipant version with the name of the current git branch. Default: false"
        method_option :broker_base_url, required: true, aliases: "-b", desc: "The base URL of the Pact Broker"
        method_option :broker_username, aliases: "-u", desc: "Pact Broker basic auth username"
        method_option :broker_password, aliases: "-p", desc: "Pact Broker basic auth password"
        method_option :broker_token, aliases: "-k", desc: "Pact Broker bearer token"
        method_option :verbose, aliases: "-v", type: :boolean, default: false, required: false, desc: "Verbose output. Default: false"

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
        method_option :broker_base_url, required: true, aliases: "-b", desc: "The base URL of the Pact Broker"
        method_option :broker_username, aliases: "-u", desc: "Pact Broker basic auth username"
        method_option :broker_password, aliases: "-p", desc: "Pact Broker basic auth password"
        method_option :broker_token, aliases: "-k", desc: "Pact Broker bearer token"
        method_option :output, aliases: "-o", desc: "json or table or id", default: 'table'
        method_option :verbose, aliases: "-v", type: :boolean, default: false, required: false, desc: "Verbose output. Default: false"

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

        shared_options_for_webhook_commands

        desc 'create-webhook URL', 'Creates a webhook using the same switches as a curl request.'
        long_desc File.read(File.join(File.dirname(__FILE__), 'create_webhook_long_desc.txt'))
        def create_webhook webhook_url
          run_webhook_commands webhook_url
        end

        shared_options_for_webhook_commands
        method_option :uuid, type: :string, required: true, desc: "Specify the uuid for the webhook"

        desc 'create-or-update-webhook URL', 'Creates or updates a webhook with a provided uuid and using the same switches as a curl request.'
        long_desc File.read(File.join(File.dirname(__FILE__), 'create_or_update_webhook_long_desc.txt'))
        def create_or_update_webhook webhook_url
          run_webhook_commands webhook_url
        end

        desc 'test-webhook', 'Test the execution of a webhook'
        method_option :uuid, type: :string, required: true, desc: "Specify the uuid for the webhook"
        shared_authentication_options_for_pact_broker
        def test_webhook
          require 'pact_broker/client/webhooks/test'
          result = PactBroker::Client::Webhooks::Test.call(options, pact_broker_client_options)
          $stdout.puts result.message
        end

        ignored_and_hidden_potential_options_from_environment_variables
        desc 'generate-uuid', 'Generate a UUID for use when calling create-or-update-webhook'
        def generate_uuid
          require 'securerandom'

          puts SecureRandom.uuid
        end

        desc 'create-or-update-pacticipant', 'Create or update pacticipant by name'
        method_option :name, type: :string, required: true, desc: "Pacticipant name"
        method_option :repository_url, type: :string, required: false, desc: "The repository URL of the pacticipant"
        shared_authentication_options_for_pact_broker
        verbose_option
        def create_or_update_pacticipant(*required_but_ignored)
          raise ::Thor::RequiredArgumentMissingError, "Pacticipant name cannot be blank" if options.name.strip.size == 0
          require 'pact_broker/client/pacticipants/create'
          result = PactBroker::Client::Pacticipants2::Create.call({ name: options.name, repository_url: options.repository_url }, options.broker_base_url, pact_broker_client_options)
          $stdout.puts result.message
          exit(1) unless result.success
        end

        desc 'list-latest-pact-versions', 'List the latest pact for each integration'
        shared_authentication_options_for_pact_broker
        method_option :output, aliases: "-o", desc: "json or table", default: 'table'
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

            PactBroker::Client::PublishPacts.call(
              options.broker_base_url,
              file_list(pact_files),
              options.consumer_app_version,
              tags,
              pact_broker_client_options
            )
          end

          def file_list pact_files
            require 'rake/file_list'

            correctly_separated_pact_files = pact_files.collect{ |path| path.gsub(/\\+/, '/') }
            Rake::FileList[correctly_separated_pact_files].collect do | path |
              if File.directory?(path)
                Rake::FileList[File.join(path, "*.json")]
              else
                path
              end
            end.flatten
          end

          def tags
            require 'pact_broker/client/git'

            t = [*options.tag]
            t << PactBroker::Client::Git.branch if options.tag_with_git_branch
            t.compact.uniq
          end

          def pact_broker_client_options
            client_options = { verbose: options.verbose }
            client_options[:token] =  options.broker_token if options.broker_token
            if options.broker_username
              client_options[:basic_auth] = {
                  username: options.broker_username,
                  password: options.broker_password
                }
            end

            client_options
          end

          def parse_webhook_events
            events = []
            events << 'contract_content_changed' if options.contract_content_changed
            events << 'contract_published' if options.contract_published
            events << 'provider_verification_published' if options.provider_verification_published
            events << 'provider_verification_succeeded' if options.provider_verification_succeeded
            events << 'provider_verification_failed' if options.provider_verification_failed
            events
          end

          def parse_webhook_options(webhook_url)
            events = parse_webhook_events

            if events.size == 0
              raise WebhookCreationError.new("You must specify at least one of --contract-content-changed, --contract-published, --provider-verification-published, --provider-verification-succeeded or --provider-verification-failed")
            end

            username = options.user ? options.user.split(":", 2).first : nil
            password = options.user ? options.user.split(":", 2).last : nil

            headers = (options.header || []).each_with_object({}) { | header, headers | headers[header.split(":", 2).first.strip] = header.split(":", 2).last.strip }

            body = options.data
            if body && body.start_with?("@")
              filepath = body[1..-1]
              begin
                body = File.read(filepath)
              rescue StandardError => e
                raise WebhookCreationError.new("Couldn't read data from file \"#{filepath}\" due to #{e.class} #{e.message}")
              end
            end

            {
              uuid: options.uuid,
              description: options.description,
              http_method: options.request,
              url: webhook_url,
              headers: headers,
              username: username,
              password: password,
              body: body,
              consumer: options.consumer,
              provider: options.provider,
              events: events
            }

          end

          def run_webhook_commands webhook_url
            require 'pact_broker/client/webhooks/create'

            validate_credentials
            result = PactBroker::Client::Webhooks::Create.call(parse_webhook_options(webhook_url), options.broker_base_url, pact_broker_client_options)
            $stdout.puts result.message
            exit(1) unless result.success
          rescue PactBroker::Client::Error => e
            raise WebhookCreationError, "#{e.class} - #{e.message}"
          end
        end
      end
    end
  end
end
