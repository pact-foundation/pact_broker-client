require "pact_broker/client/hash_refinements"

module Pactflow
  module Client
    module CLI
      module ProviderContractCommands
        using PactBroker::Client::HashRefinements

        def self.included(thor)
          thor.class_eval do
            desc 'publish-provider-contract CONTRACT_FILE ...', "Publish provider contract to Pactflow"
            method_option :provider, required: true, desc: "The provider name"
            method_option :provider_app_version, required: true, aliases: "-a", desc: "The provider application version"
            method_option :branch, aliases: "-h", desc: "Repository branch of the provider version"
            #method_option :auto_detect_version_properties, hidden: true, type: :boolean, default: false, desc: "Automatically detect the repository branch from known CI environment variables or git CLI."
            method_option :tag, aliases: "-t", type: :array, banner: "TAG", desc: "Tag name for provider version. Can be specified multiple times."
            #method_option :tag_with_git_branch, aliases: "-g", type: :boolean, default: false, required: false, desc: "Tag consumer version with the name of the current git branch. Default: false"
            method_option :specification, default: "oas", desc: "The contract specification"
            method_option :content_type, desc: "The content type. eg. application/yml"
            method_option :verification_success, type: :boolean, desc: "Whether or not the self verification passed successfully."
            method_option :verification_exit_code, type: :numeric, desc: "The exit code of the verification process. Can be used instead of --verification-success|--no-verification-success for a simpler build script."
            method_option :verification_results, desc: "The path to the file containing the output from the verification process"
            method_option :verification_results_content_type, desc: "The content type of the verification output eg. text/plain, application/yaml"
            method_option :verification_results_format, desc: "The format of the verification output eg. junit, text"
            method_option :verifier, desc: "The tool used to verify the provider contract"
            method_option :verifier_version, desc: "The version of the tool used to verify the provider contract"
            #method_option :build_url, desc: "The build URL that created the pact"

            output_option_json_or_text
            shared_authentication_options

            def publish_provider_contract(provider_contract_path)
              require "pactflow/client/provider_contracts/publish"

              validate_publish_provider_contract_options(provider_contract_path)
              result = ::Pactflow::Client::ProviderContracts::Publish.call(
                          publish_provider_contract_command_params(provider_contract_path),
                          command_options,
                          pact_broker_client_options
                        )
              $stdout.puts result.message
              exit(1) unless result.success
            end

            no_commands do
              def command_options
                { verbose: options.verbose, output: options.output }
              end

              def validate_publish_provider_contract_options(provider_contract_path)
                if !options.verification_success.nil? && options.verification_exit_code
                  raise Thor::Error, "Cannot use both --verification-success|--no-verification-success and --verification-exit-code"
                end
              end

              def publish_provider_contract_command_params(provider_contract_path)
                success = !options.verification_success.nil? ? options.verification_success : ( options.verification_exit_code && options.verification_exit_code == 0 )

                {
                  provider_name: options.provider.strip,
                  provider_version_number: options.provider_app_version.strip,
                  branch_name: options.branch && options.branch.strip,
                  tags: (options.tag && options.tag.collect(&:strip)) || [],
                  contract: {
                    content: File.read(provider_contract_path),
                    content_type: options.content_type,
                    specification: options.specification
                  },
                  verification_results: {
                    success: success,
                    content: options.verification_results ? File.read(options.verification_results) : nil,
                    content_type: options.verification_results_content_type,
                    format: options.verification_results_format,
                    verifier: options.verifier,
                    verifier_version: options.verifier_version
                  }
                }
              end
            end
          end
        end
      end
    end
  end
end
