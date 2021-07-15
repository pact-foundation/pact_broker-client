module PactBroker
  module Client
    module CLI
      module MatrixCommands

        def self.included(thor)
          thor.class_eval do
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
          end
        end
      end
    end
  end
end