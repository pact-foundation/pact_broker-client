require "pact_broker/client/string_refinements"
module PactBroker
  module Client
    module CLI
      module MatrixCommands
        using PactBroker::Client::StringRefinements

        def self.included(thor)
          thor.class_eval do

            desc "can-i-deploy", "Checks if the specified pacticipant version is safe to be deployed."
            long_desc File.read(File.join(__dir__, "can_i_deploy_long_desc.txt"))

            method_option :pacticipant, required: true, aliases: "-a", desc: "The pacticipant name. Use once for each pacticipant being checked."
            method_option :version, required: false, aliases: "-e", desc: "The pacticipant version. Must be entered after the --pacticipant that it relates to."
            method_option :ignore, required: false, banner: "PACTICIPANT", desc: "The pacticipant name to ignore. Use once for each pacticipant being ignored. A specific version can be ignored by also specifying a --version after the pacticipant name option. The environment variable PACT_BROKER_CAN_I_DEPLOY_IGNORE may also be used to specify a pacticipant name to ignore, with commas to separate multiple pacticipant names if necessary."
            method_option :latest, required: false, aliases: "-l", banner: "[TAG]", desc: "Use the latest pacticipant version. Optionally specify a TAG to use the latest version with the specified tag."
            method_option :branch, required: false, desc: "The branch of the version for which you want to check the verification results.", default: nil
            method_option :main_branch, required: false, type: :boolean, desc: "Use the latest version of the configured main branch of the pacticipant as the version for which you want to check the verification results", default: false
            method_option :to_environment, required: false, banner: "ENVIRONMENT", desc: "The environment into which the pacticipant(s) are to be deployed", default: nil
            method_option :to, required: false, banner: "TAG", desc: "The tag that represents the branch or environment of the integrated applications for which you want to check the verification result status.", default: nil
            method_option :output, aliases: "-o", desc: "json or table", default: "table"
            method_option :retry_while_unknown, banner: "TIMES", type: :numeric, default: 0, required: false, desc: "The number of times to retry while there is an unknown verification result (ie. the provider verification is likely still running)"
            method_option :retry_interval, banner: "SECONDS", type: :numeric, default: 10, required: false, desc: "The time between retries in seconds. Use in conjuction with --retry-while-unknown"
            # Allow limit to be set manually until https://github.com/pact-foundation/pact_broker-client/issues/53 is fixed
            method_option :limit, hide: true
            method_option :dry_run, type: :boolean, default: false, desc: "When dry-run is enabled, always exit process with a success code. Can also be enabled by setting the environment variable PACT_BROKER_CAN_I_DEPLOY_DRY_RUN=true. This mode is useful when setting up your CI/CD pipeline for the first time, or in a 'break glass' situation where you need to knowingly deploy what Pact considers a breaking change. For the second scenario, it is recommended to use the environment variable and just set it for the build required to deploy that particular version, so you don't accidentally leave the dry run mode enabled."
            shared_authentication_options

            def can_i_deploy(*ignored_but_necessary)
              require "pact_broker/client/cli/version_selector_options_parser"
              require "pact_broker/client/can_i_deploy"

              validate_credentials
              selectors = VersionSelectorOptionsParser.call(ARGV).select { |s| !s[:ignore] }
              ignore_selectors = VersionSelectorOptionsParser.call(ARGV).select { |s| s[:ignore] } + ignore_selectors_from_environment_variable
              validate_can_i_deploy_selectors(selectors)
              validate_can_i_deploy_options
              dry_run = options.dry_run || ENV["PACT_BROKER_CAN_I_DEPLOY_DRY_RUN"] == "true"
              can_i_deploy_options = { output: options.output, retry_while_unknown: options.retry_while_unknown, retry_interval: options.retry_interval, dry_run: dry_run, verbose: options.verbose }
              result = CanIDeploy.call(selectors, { to_tag: options.to, to_environment: options.to_environment, limit: options.limit, ignore_selectors: ignore_selectors }, can_i_deploy_options, pact_broker_client_options)
              $stdout.puts result.message
              $stdout.flush
              exit(can_i_deploy_exit_status) unless result.success
            end

            desc "can-i-merge", "Checks if the specified pacticipant version is safe to merge into the main branch."
            long_desc "Checks if the specified pacticipant version is compatible with the configured main branch of each of the pacticipants with which it is integrated."
            method_option :pacticipant, required: true, aliases: "-a", desc: "The pacticipant name. Use once for each pacticipant being checked."
            method_option :version, required: false, aliases: "-e", desc: "The pacticipant version. Must be entered after the --pacticipant that it relates to."
            method_option :output, aliases: "-o", desc: "json or table", default: "table"
            method_option :retry_while_unknown, banner: "TIMES", type: :numeric, default: 0, required: false, desc: "The number of times to retry while there is an unknown verification result (ie. the provider verification is likely still running)"
            method_option :retry_interval, banner: "SECONDS", type: :numeric, default: 10, required: false, desc: "The time between retries in seconds. Use in conjuction with --retry-while-unknown"
            method_option :dry_run, type: :boolean, default: false, desc: "When dry-run is enabled, always exit process with a success code. Can also be enabled by setting the environment variable PACT_BROKER_CAN_I_MERGE_DRY_RUN=true. This mode is useful when setting up your CI/CD pipeline for the first time, or in a 'break glass' situation where you need to knowingly deploy what Pact considers a breaking change. For the second scenario, it is recommended to use the environment variable and just set it for the build required to deploy that particular version, so you don't accidentally leave the dry run mode enabled."
            shared_authentication_options

            def can_i_merge(*ignored_but_necessary)
              require "pact_broker/client/cli/version_selector_options_parser"
              require "pact_broker/client/can_i_deploy"

              validate_credentials
              selectors = VersionSelectorOptionsParser.call(ARGV)
              validate_can_i_deploy_selectors(selectors)
              dry_run = options.dry_run || ENV["PACT_BROKER_CAN_I_MERGE_DRY_RUN"] == "true"
              can_i_merge_options = { output: options.output, retry_while_unknown: options.retry_while_unknown, retry_interval: options.retry_interval, dry_run: dry_run, verbose: options.verbose }
              result = CanIDeploy.call(selectors, { with_main_branches: true  }, can_i_merge_options, pact_broker_client_options)
              $stdout.puts result.message
              $stdout.flush
              exit(1) unless result.success
            end

            if ENV.fetch("PACT_BROKER_FEATURES", "").include?("verification_required")

              method_option :pacticipant, required: true, aliases: "-a", desc: "The pacticipant name. Use once for each pacticipant being checked."
              method_option :version, required: false, aliases: "-e", desc: "The pacticipant version. Must be entered after the --pacticipant that it relates to."
              method_option :latest, required: false, aliases: "-l", banner: "[TAG]", desc: "Use the latest pacticipant version. Optionally specify a TAG to use the latest version with the specified tag."
              method_option :to, required: false, banner: "TAG", desc: "This is too hard to explain in a short sentence. Look at the examples.", default: nil
              method_option :in_environment, required: false, banner: "ENVIRONMENT", desc: "The environment into which the pacticipant(s) are to be deployed", default: nil, hide: true
              method_option :output, aliases: "-o", desc: "json or table", default: "table"

              shared_authentication_options
              desc "verification-required", "Checks if there is a verification required between the given pacticipant versions."
              def verification_required(*ignored_but_necessary)
                require "pact_broker/client/cli/version_selector_options_parser"
                require "pact_broker/client/verification_required"

                validate_credentials
                selectors = VersionSelectorOptionsParser.call(ARGV)
                validate_can_i_deploy_selectors(selectors)
                verification_required_options = { output: options.output, verbose: options.verbose, retry_while_unknown: 0 }
                result = VerificationRequired.call(selectors, { to_tag: options.to, to_environment: options.in_environment, ignore_selectors: [] }, verification_required_options, pact_broker_client_options)
                $stdout.puts result.message
                $stdout.flush
                exit(1) unless result.success
              end

            end

            no_commands do
              def can_i_deploy_exit_status
                exit_code_string = ENV.fetch("PACT_BROKER_CAN_I_DEPLOY_EXIT_CODE_BETA", "")
                if exit_code_string =~ /^\d+$/
                  $stderr.puts "Exiting can-i-deploy with configured exit code #{exit_code_string}"
                  exit_code_string.to_i
                else
                  1
                end
              end

              def validate_can_i_deploy_selectors(selectors)
                pacticipants_without_versions = selectors.select{ |s| s[:version].nil? && s[:latest].nil? && s[:tag].nil? && s[:branch].nil? }.collect{ |s| s[:pacticipant] }
                raise ::Thor::RequiredArgumentMissingError, "The version must be specified using `--version VERSION`, `--branch BRANCH` `--latest`, `--latest TAG`, or `--all TAG` for pacticipant #{pacticipants_without_versions.join(", ")}" if pacticipants_without_versions.any?
              end

              def validate_can_i_deploy_options
                if options[:to_environment] && options[:to_environment].blank?
                  raise ::Thor::RequiredArgumentMissingError, "The environment name cannot be blank"
                end
              end

              def ignore_selectors_from_environment_variable
                ENV.fetch("PACT_BROKER_CAN_I_DEPLOY_IGNORE", "").split(",").collect(&:strip).collect{ |i| { pacticipant: i } }
              end
            end
          end
        end
      end
    end
  end
end