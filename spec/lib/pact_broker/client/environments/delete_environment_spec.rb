require 'pact_broker/client/environments/delete_environment'

module PactBroker
  module Client
    module Environments
      describe DeleteEnvironment do
        before do
          allow_any_instance_of(PactBroker::Client::Hal::HttpClient).to receive(:sleep)
          allow_any_instance_of(PactBroker::Client::Hal::HttpClient).to receive(:default_max_tries).and_return(1)
        end

        let(:params) do
          {
            uuid: uuid,
            name: "new name",
            displayName: "new display name",
            production: false,
            output: output
          }
        end
        let(:options) do
          {
            output: output,
            verbose: verbose
          }
        end
        let(:uuid) { "a9aa4c22-66bb-45d3-ba4c-4916ac8b48c5" }
        let(:pact_broker_base_url) { "http://example.org" }
        let(:pact_broker_client_options) { { pact_broker_base_url: pact_broker_base_url } }
        let(:response_headers) { { "Content-Type" => "application/hal+json"} }
        let(:output) { "text" }
        let(:verbose) { false }

        before do
          stub_request(:get, "http://example.org/").to_return(status: 200, body: index_response_body, headers: response_headers)
          stub_request(:get, "http://example.org/environments/#{uuid}").to_return(status: get_environment_response_status, body: get_environment_response_body, headers: response_headers)
          stub_request(:delete, "http://example.org/environments/#{uuid}").to_return(status: delete_response_status, body: delete_environment_response_body, headers: response_headers)
        end
        let(:delete_response_status) { 200 }
        let(:get_environment_response_status) { 200 }

        let(:index_response_body) do
          {
            "_links" => {
              "pb:environments" => {},
              "pb:environment" => {
                "href" => "http://example.org/environments/{uuid}"
              }
            }
          }.to_json
        end

        let(:get_environment_response_body) do
          {
            name: "existing name",
            displayName: "existing display name",
            production: true
          }.to_json
        end

        let(:delete_environment_response_body) do
          JSON.parse(get_environment_response_body).merge("updatedAt" => "2021-05-28T13:34:54+10:00").to_json
        end

        subject { DeleteEnvironment.call(params, options, pact_broker_client_options) }

        context "when delete is successful" do
          its(:success) { is_expected.to be true }
          its(:message) { is_expected.to include "Deleted environment existing name from the Pact Broker" }

          context "when output is json" do
            let(:output) { "json" }

            its(:message) { is_expected.to eq delete_environment_response_body }
          end
        end

        context "when environments are not supported" do
          let(:index_response_body) { "{}" }

          its(:success) { is_expected.to be false }
          its(:message) { is_expected.to include "does not support environments" }
        end

        context "when the environment does not exist" do
          let(:get_environment_response_status) { 404 }
          let(:get_environment_response_body) { "" }
          let(:delete_environment_response_body) { "" }

          its(:success) { is_expected.to be false }
          its(:message) { is_expected.to include get_environment_response_body }

          context "when output is json" do
            let(:output) { "json" }

            its(:message) { is_expected.to eq "{}" }
          end
        end

        context "when delete is unsuccessful" do
          let(:delete_response_status) { 500 }
          let(:delete_environment_response_body) do
            {
              "some" => "error"
            }.to_json
          end

          its(:success) { is_expected.to be false }
          its(:message) { is_expected.to include delete_environment_response_body }

          context "when output is json" do
            let(:output) { "json" }

            its(:message) { is_expected.to eq delete_environment_response_body }
          end
        end
      end
    end
  end
end
