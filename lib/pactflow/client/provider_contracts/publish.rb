require "base64"
require "pact_broker/client/base_command"
require "pact_broker/client/colorize_notices"
require "pactflow/client/provider_contracts/publish_the_old_way"
require 'ostruct'

module Pactflow
  module Client
    module ProviderContracts
      class Publish < PactBroker::Client::BaseCommand
        PUBLISH_RELATION = "pf:publish-provider-contract"


        def initialize(params, options, pact_broker_client_options)
          super
          @provider_name = params[:provider_name]
          @provider_version_number = params[:provider_version_number]
          @branch_name = params[:branch_name]
          @tags = params[:tags] || []
          @build_url = params[:build_url]
          @contract = params[:contract]
          @verification_results = params[:verification_results]
        end

        private

        attr_reader :provider_name, :provider_version_number, :branch_name, :tags, :build_url, :contract, :verification_results

        def do_call
          if !disabled? && index_resource.assert_success!.can?(PUBLISH_RELATION)
            publish_provider_contracts
            PactBroker::Client::CommandResult.new(success?, message)
          else
            PublishTheOldWay.call(params, options, pact_broker_client_options)
          end
        end

        def disabled?
          ENV.fetch("PACTFLOW_FEATURES", "").include?("publish_provider_contracts_using_old_api")
        end

        def publish_provider_contracts
          @response_entity = index_resource._link(PUBLISH_RELATION).expand(provider: provider_name).post!(contract_params, { "Accept" => "application/hal+json,application/problem+json" })
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

          contract_params = {
                              content: encode_content(contract[:content]),
                              specification: contract[:specification],
                              contentType: contract[:content_type]
                            }.compact

          if verification_results_params.any?
            contract_params[:selfVerificationResults] = verification_results_params
          end

          {
            pacticipantVersionNumber: provider_version_number,
            tags: tags,
            branch: branch_name,
            buildUrl: build_url,
            contract: contract_params
          }
        end

        def encode_content oas
          Base64.strict_encode64(oas)
        end

        def message
          if options[:output] == "json"
            @response_entity.response.raw_body
          else
            text_message
          end
        end

        def success?
          @response_entity.success?
        end

        def text_message
          PactBroker::Client::ColorizeNotices.call(@response_entity.notices.collect{ |n| OpenStruct.new(n) } )
        end
      end
    end
  end
end
