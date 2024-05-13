require "pact_broker/client/base_command"
require "pact_broker/client/versions/create"
require 'pact_broker/client/colorize_notices'
require "base64"
require 'ostruct'

module Pactflow
  module Client
    module ProviderContracts
      class PublishTheOldWay < PactBroker::Client::BaseCommand
        attr_reader :branch_name, :tags, :provider_name, :provider_version_number, :contract, :verification_results

        def initialize(params, options, pact_broker_client_options)
          super
          @provider_name = params[:provider_name]
          @provider_version_number = params[:provider_version_number]
          @branch_name = params[:branch_name]
          @tags = params[:tags] || []
          @contract = params[:contract]
          @verification_results = params[:verification_results]
        end

        private

        def do_call
          create_branch_version_and_tags
          render_response(create_contract)
        end

        def render_response(res)
          notices = [
            { type: 'success', text: "Successfully published provider contract for #{provider_name} version #{provider_version_number} to PactFlow"},
          ]
          if res.body && res.body['_links'] && res.body['_links']['pf:ui']['href']
            notices.concat([{ text: "View the uploaded contract at #{res.body['_links']['pf:ui']['href']}" }])
          end
          notices.concat(next_steps)
          PactBroker::Client::CommandResult.new(true, PactBroker::Client::ColorizeNotices.call(notices.collect do |n|
                                                                                                 OpenStruct.new(n)
                                                                                               end).join("\n"))
        end

        def next_steps
          [
            { type: 'prompt', text: 'Next steps:' },
            { type: 'prompt',
              text: '  * Check your application is safe to deploy - https://docs.pact.io/can_i_deploy' },
            { text: "       pact-broker can-i-deploy --pacticipant #{provider_name} --version #{provider_version_number} --to-environment <your environment name>" },
            { type: 'prompt',
              text: '  * Record deployment or release to specified environment (choose one) - https://docs.pact.io/go/record-deployment' },
            { text: "       pact-broker record-deployment --pacticipant #{provider_name} --version #{provider_version_number} --environment <your environment name>" },
            { text: "       pact-broker record-release --pacticipant #{provider_name} --version #{provider_version_number} --environment <your environment name>" }
          ]
        end

        def create_branch_version_and_tags
          if branch_name || tags.any?
            pacticipant_version_params = {
              pacticipant_name: provider_name,
              version_number: provider_version_number,
              branch_name: branch_name,
              tags: tags
            }
            result = PactBroker::Client::Versions::Create.call(pacticipant_version_params, options, pact_broker_client_options)
            if !result.success
              raise PactBroker::Client::Error.new(result.message)
            end
          end
        end

        def create_contract
          contract_path = "#{pact_broker_base_url}/contracts/provider/{provider}/version/{version}"
          entrypoint = create_entry_point(contract_path, pact_broker_client_options)
          entrypoint.expand(provider: provider_name, version: provider_version_number).put!(contract_params).response
        end

        def contract_params
          verification_results_params = {
                                          success: verification_results[:success],
                                          content:  verification_results[:content] ? encode_content(verification_results[:content]) : nil,
                                          contentType: verification_results[:content_type],
                                          format: verification_results[:format],
                                          verifier: verification_results[:verifier],
                                          verifierVersion: verification_results[:verifier_version]
                                        }.compact
                                        
          body_params = {
                          content: encode_content(contract[:content]),
                          contractType: contract[:specification],
                          contentType: contract[:content_type],
                        }.compact

          if verification_results_params.any?
            body_params[:verificationResults] = verification_results_params
          end
          body_params
        end

        def encode_content oas
          Base64.strict_encode64(oas)
        end
      end
    end
  end
end
