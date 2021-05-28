require 'pact_broker/client/environments/update_environment'

module PactBroker
  module Client
    module Environments
      describe UpdateEnvironment do
        before do
          allow_any_instance_of(PactBroker::Client::Hal::HttpClient).to receive(:sleep)
          allow_any_instance_of(PactBroker::Client::Hal::HttpClient).to receive(:default_max_tries).and_return(1)
        end

        let(:params) do
          {
            uuid: uuid,
            name: "new name",
            display_name: "new display name",
            production: false,
            output: output
          }
        end
        let(:uuid) { "a9aa4c22-66bb-45d3-ba4c-4916ac8b48c5" }
        let(:pact_broker_base_url) { "http://example.org" }
        let(:pact_broker_client_options) { {} }
        let(:response_headers) { { "Content-Type" => "application/hal+json"} }
        let(:output) { "text" }

        before do
          stub_request(:get, "http://example.org/").to_return(status: 200, body: index_response_body, headers: response_headers)
          stub_request(:get, "http://example.org/environments/#{uuid}").to_return(status: get_environment_response_status, body: get_environment_response_body, headers: response_headers)
          stub_request(:put, "http://example.org/environments/#{uuid}").to_return(status: put_response_status, body: put_environment_response_body, headers: response_headers)
        end
        let(:put_response_status) { 200 }
        let(:get_environment_response_status) { 200 }
        let(:put_request_body) do
          {
            name: "new name",
            displayName: "new display name",
            production: false
          }.to_json
        end

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

        let(:put_environment_response_body) do
          JSON.parse(get_environment_response_body).merge("updatedAt" => "2021-05-28T13:34:54+10:00").to_json
        end

        subject { UpdateEnvironment.call(params, pact_broker_base_url, pact_broker_client_options) }

        it "updates the environment" do
          request = stub_request(:put, "http://example.org/environments/#{uuid}").with(body: put_request_body)
          subject
          expect(request).to have_been_made
        end

        context "when update is successful" do
          its(:success) { is_expected.to be true }
          its(:message) { is_expected.to include "Updated new name environment in the Pact Broker" }

          context "when output is json" do
            let(:output) { "json" }

            its(:message) { is_expected.to eq put_environment_response_body }
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
          let(:put_environment_response_body) { "" }

          its(:success) { is_expected.to be false }
          its(:message) { is_expected.to include get_environment_response_body }

          context "when output is json" do
            let(:output) { "json" }

            its(:message) { is_expected.to eq "{}" }
          end
        end

        context "when update is unsuccessful" do
          let(:put_response_status) { 400 }
          let(:put_environment_response_body) do
            {
              "some" => "error"
            }.to_json
          end

          its(:success) { is_expected.to be false }
          its(:message) { is_expected.to include put_environment_response_body }

          context "when output is json" do
            let(:output) { "json" }

            its(:message) { is_expected.to eq put_environment_response_body }
          end
        end
      end
    end
  end
end
