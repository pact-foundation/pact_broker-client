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
            method_option :verification_success, type: :boolean
            method_option :verification_results, desc: "The path to the file containing the output from the verification process"
            method_option :verification_results_format, desc: "The format of the verification output eg. junit, text"
            method_option :verifier, desc: "The tool used to verify the provider contract"
            method_option :verifier_version, desc: "The version of the tool used to verify the provider contract"
            #method_option :build_url, desc: "The build URL that created the pact"

            output_option_json_or_text
            shared_authentication_options

            def publish_provider_contract(provider_contract_path)
              puts provider_contract_path
              puts options
            end
          end
        end
      end
    end
  end
end
