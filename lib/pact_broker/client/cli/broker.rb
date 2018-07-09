require 'pact_broker/client/version'
require 'pact_broker/client/can_i_deploy'
require 'pact_broker/client/git'
require 'pact_broker/client/cli/version_selector_options_parser'
require 'pact_broker/client/cli/custom_thor'
require 'pact_broker/client/publish_pacts'
require 'rake/file_list'
require 'thor/error'
require 'pact_broker/client/create_tag'
require 'pact_broker/client/versions/describe'

module PactBroker
  module Client
    module CLI
      # Thor::Error will have its backtrace hidden
      class PactPublicationError < ::Thor::Error; end
      class WebhookCreationError < ::Thor::Error; end

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
        method_option :output, aliases: "-o", desc: "json or table", default: 'table'
        method_option :verbose, aliases: "-v", type: :boolean, default: false, required: false, desc: "Verbose output. Default: false"
        method_option :retry_while_unknown, banner: 'TIMES', type: :numeric, default: 0, required: false, desc: "The number of times to retry while there is an unknown verification result (ie. the provider verification is likely still running)"
        method_option :retry_interval, banner: 'SECONDS', type: :numeric, default: 10, required: false, desc: "The time between retries in seconds. Use in conjuction with --retry-while-unknown"

        def can_i_deploy(*ignored_but_necessary)
          selectors = VersionSelectorOptionsParser.call(ARGV)
          validate_can_i_deploy_selectors(selectors)
          can_i_deploy_options = { output: options.output, retry_while_unknown: options.retry_while_unknown, retry_interval: options.retry_interval }
          result = CanIDeploy.call(options.broker_base_url, selectors, {to_tag: options.to}, can_i_deploy_options, pact_broker_client_options)
          $stdout.puts result.message
          exit(1) unless result.success
        end

        desc 'publish PACT_DIRS_OR_FILES ...', "Publish pacts to a Pact Broker."
        method_option :consumer_app_version, required: true, aliases: "-a", desc: "The consumer application version"
        method_option :broker_base_url, required: true, aliases: "-b", desc: "The base URL of the Pact Broker"
        method_option :broker_username, aliases: "-u", desc: "Pact Broker basic auth username"
        method_option :broker_password, aliases: "-p", desc: "Pact Broker basic auth password"
        method_option :tag, aliases: "-t", type: :array, banner: "TAG", desc: "Tag name for consumer version. Can be specified multiple times."
        method_option :tag_with_git_branch, aliases: "-g", type: :boolean, default: false, required: false, desc: "Tag consumer version with the name of the current git branch. Default: false"
        method_option :verbose, aliases: "-v", type: :boolean, default: false, required: false, desc: "Verbose output. Default: false"

        def publish(*pact_files)
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
        method_option :tag_with_git_branch, aliases: "-g", type: :boolean, default: false, required: false, desc: "Tag pacticipant version with the name of the current git branch. Default: false"
        method_option :broker_base_url, required: true, aliases: "-b", desc: "The base URL of the Pact Broker"
        method_option :broker_username, aliases: "-u", desc: "Pact Broker basic auth username"
        method_option :broker_password, aliases: "-p", desc: "Pact Broker basic auth password"
        method_option :verbose, aliases: "-v", type: :boolean, default: false, required: false, desc: "Verbose output. Default: false"

        def create_version_tag
          PactBroker::Client::CreateTag.call(
            options.broker_base_url,
            options.pacticipant,
            options.version,
            tags,
            pact_broker_client_options)
        end

        method_option :pacticipant, required: true, aliases: "-a", desc: "The name of the pacticipant that the version belongs to."
        method_option :version, required: false, aliases: "-e", desc: "The pacticipant version number."
        method_option :latest, required: false, aliases: "-l", banner: '[TAG]', desc: "Describe the latest pacticipant version. Optionally specify a TAG to describe the latest version with the specified tag."
        method_option :broker_base_url, required: true, aliases: "-b", desc: "The base URL of the Pact Broker"
        method_option :broker_username, aliases: "-u", desc: "Pact Broker basic auth username"
        method_option :broker_password, aliases: "-p", desc: "Pact Broker basic auth password"
        method_option :output, aliases: "-o", desc: "json or table or id", default: 'table'
        method_option :verbose, aliases: "-v", type: :boolean, default: false, required: false, desc: "Verbose output. Default: false"

        desc 'describe-version', 'Describes a pacticipant version. If no version or tag is specified, the latest version is described.'
        def describe_version
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

        method_option :request, aliases: "-X", desc: "HTTP method", required: true
        method_option :header, aliases: "-H", type: :array, desc: "Header"
        method_option :data, aliases: "-d", desc: "Data"
        method_option :user, aliases: "-u", desc: "Basic auth username and password eg. username:password"
        method_option :consumer, desc: "Consumer name"
        method_option :provider, desc: "Provider name"
        method_option :broker_base_url, required: true, aliases: "-b", desc: "The base URL of the Pact Broker"
        method_option :broker_username, aliases: "-u", desc: "Pact Broker basic auth username"
        method_option :broker_password, aliases: "-p", desc: "Pact Broker basic auth password"
        method_option :contract_content_changed, type: :boolean, desc: "Trigger this webhook when the pact content changes"
        method_option :provider_verification_published, type: :boolean, desc: "Trigger this webhook when a provider verification result is published"
        method_option :verbose, aliases: "-v", type: :boolean, default: false, required: false, desc: "Verbose output. Default: false"

        desc 'create-webhook URL', 'Creates a webhook using the same switches as a curl request.'
        long_desc File.read(File.join(File.dirname(__FILE__), 'create_webhook_long_desc.txt'))
        def create_webhook webhook_url
          require 'pact_broker/client/webhooks/create'

          if !(options.contract_content_changed || options.provider_verification_published)
            raise PactBroker::Client::Error.new("You must select at least one of --contract-content-changed or --provider-verification-published")
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
              raise PactBroker::Client::Error.new("Couldn't read data from file \"#{filepath}\" due to #{e.class} #{e.message}")
            end
          end

          events = []
          events << 'contract_content_changed' if options.contract_content_changed
          events << 'provider_verification_published' if options.provider_verification_published

          params = {
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

          begin
            result = PactBroker::Client::Webhooks::Create.call(params, options.broker_base_url, pact_broker_client_options)
            $stdout.puts result.message
            exit(1) unless result.success
          rescue PactBroker::Client::Error => e
            raise WebhookCreationError, "#{e.class} - #{e.message}"
          end
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
              raise ::Thor::RequiredArgumentMissingError, "No value provided for required pact_files"
            end
          end

          def validate_can_i_deploy_selectors selectors
            pacticipants_without_versions = selectors.select{ |s| s[:version].nil? && s[:latest].nil? }.collect{ |s| s[:pacticipant] }
            raise ::Thor::RequiredArgumentMissingError, "The version must be specified using --version or --latest [TAG] for pacticipant #{pacticipants_without_versions.join(", ")}" if pacticipants_without_versions.any?
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
            t = [*options.tag]
            t << PactBroker::Client::Git.branch if options.tag_with_git_branch
            t.compact.uniq
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
