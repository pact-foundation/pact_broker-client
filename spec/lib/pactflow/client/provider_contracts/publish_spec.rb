require "pactflow/client/provider_contracts/publish"
require 'ostruct'

module Pactflow
  module Client
    module ProviderContracts
      describe Publish do
        before do
          allow_any_instance_of(PactBroker::Client::Hal::HttpClient).to receive(:sleep)
          allow_any_instance_of(PactBroker::Client::Hal::HttpClient).to receive(:default_max_tries).and_return(1)
        end

        let(:command_params) do
          {
            provider_name: "Bar",
            provider_version_number: "1",
            branch_name: "main",
            tags: ["dev"],
            build_url: "http://build",
            contract: {
              content: { "some" => "contract" }.to_yaml,
              content_type: "application/yaml",
              specification: "oas"
            },
            verification_results: {
              success: true,
              content: "some results",
              content_type: "text/plain",
              format: "text",
              verifier: "my custom tool",
              verifier_version: "1.0"
            }
          }
        end

        let(:options) do
          {
            verbose: false
          }
        end

        let(:pact_broker_client_options) do
          { pact_broker_base_url: "http://pactflow" }
        end

        let(:index_body_hash) do
          {
            _links: {
              "pf:publish-provider-contract" => {
                href: "http://pactflow/some-publish/{provider}"
              }
            }
          }
        end

        let(:post_response_body) do
            {
              "notices"=>[{"text"=>"some notice", "type"=>"info"}]
            }
        end

        let!(:index_request) do
          stub_request(:get, "http://pactflow")
            .to_return(
              status: index_status,
              body: index_body_hash.to_json,
              headers: { "Content-Type" => "application/hal+json" }
            )
        end
        let(:index_status) { 200 }

        let!(:publish_request) do
          stub_request(:post, "http://pactflow/some-publish/Bar")
            .to_return(
              status: publish_status,
              body: post_response_body.to_json,
              headers: { "Content-Type" => "application/hal+json" }
            )
        end
        let(:publish_status) { 200 }

        subject { Publish.call(command_params, options, pact_broker_client_options) }

        context "when there is no relation pf:publish-provider-contract" do
          before do
            allow(PublishTheOldWay).to receive(:call).with(command_params, options, pact_broker_client_options).and_return(instance_double(PactBroker::Client::CommandResult))
          end

          let(:index_body_hash) do
            {
              _links: {}
            }
          end

          it "publishes the provider contracts the old way" do
            expect(PublishTheOldWay).to receive(:call).with(command_params, options, pact_broker_client_options)
            subject
          end
        end

        context "when the feature is disabled" do
          before do
            allow(ENV).to receive(:fetch).and_call_original
            allow(ENV).to receive(:fetch).with("PACTFLOW_FEATURES", "").and_return("publish_provider_contracts_using_old_api")
          end

          it "publishes the provider contracts the old way" do
            expect(PublishTheOldWay).to receive(:call).with(command_params, options, pact_broker_client_options)
            subject
          end
        end

        it "returns a result and message" do
          expect(subject.success).to be true
          expect(subject.message).to include("some notice")
        end

        it "colourises the notices" do
          expect(PactBroker::Client::ColorizeNotices).to receive(:call).with([OpenStruct.new(text: "some notice", type: "info")]).and_return("coloured notices")
          expect(subject.message).to eq "coloured notices"
        end

        context "when the output is json" do
          let(:options) { { output: "json" } }

          it "returns the raw response" do
            expect(subject.message).to eq post_response_body.to_json
          end
        end

        context "when there is an error retrieving the index" do
          let(:index_status) { 500 }
          let(:index_body_hash) { { "some" => "error" }}

          it "returns an error result with the response body" do
            expect(subject.success).to be false
            expect(subject.message).to match(/some.*error/)
          end
        end

        context "when there is an error response from publishing" do
          let(:publish_status) { 400 }
          let(:post_response_body) do
            {
              "some" => "error"
            }
          end

          it "returns an error result with the response body" do
            expect(subject.success).to be false
            expect(subject.message).to match(/some.*error/)
          end

          context "when the output is json" do
            let(:options) { { output: "json" } }

            it "returns the raw response" do
              expect(subject.message).to eq post_response_body.to_json
            end
          end
        end

        context "when there is an error response from publishing" do
          let(:publish_status) { 400 }
          let(:post_response_body) do
            {
              "some" => "error"
            }
          end

          it "returns an error result with the response body" do
            expect(subject.success).to be false
            expect(subject.message).to match(/some.*error/)
          end
        end
      end
    end
  end
end
