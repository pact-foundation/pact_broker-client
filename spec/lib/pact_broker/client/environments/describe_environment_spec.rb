require 'pact_broker/client/environments/describe_environment'

module PactBroker
  module Client
    module Environments
      describe DescribeEnvironment do
        before do
          allow_any_instance_of(PactBroker::Client::Hal::HttpClient).to receive(:sleep)
          allow_any_instance_of(PactBroker::Client::Hal::HttpClient).to receive(:default_max_tries).and_return(1)
        end

        let(:params) { { uuid: uuid } }
        let(:options) { { output: output }}
        let(:uuid) { "a9aa4c22-66bb-45d3-ba4c-4916ac8b48c5" }
        let(:pact_broker_base_url) { "http://example.org" }
        let(:pact_broker_client_options) { { pact_broker_base_url: pact_broker_base_url } }
        let(:response_headers) { { "Content-Type" => "application/hal+json"} }
        let(:output) { "text" }

        before do
          stub_request(:get, "http://example.org/").to_return(status: 200, body: index_response_body, headers: response_headers)
          stub_request(:get, "http://example.org/environments/#{uuid}").to_return(status: get_environment_response_status, body: get_environment_response_body, headers: response_headers)
        end

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
            production: true,
            contacts: [
              name: "Someone",
              details: { emailAddress: "foo@bar.com" }
            ]
          }.to_json
        end

        subject { DescribeEnvironment.call(params, options, pact_broker_client_options) }

        context "when the environment exists" do
          its(:success) { is_expected.to be true }

          it "describes the environment" do
            Approvals.verify(subject.message, :name => "describe_environment", format: :txt)
          end

          context "when output is json" do
            let(:output) { "json" }

            its(:message) { is_expected.to eq get_environment_response_body }
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
      end
    end
  end
end
