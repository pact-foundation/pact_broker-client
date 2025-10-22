require_relative '../../../pact_ruby_v2_spec_helper'
require "yaml"
require "pactflow/client/provider_contracts/publish_the_old_way"
require "pact_broker/client/versions/create"


RSpec.describe "publishing a provider contract to PactFlow the old way", pact: true do
  before do
    # no point re-testing this
    allow(PactBroker::Client::Versions::Create).to receive(:call).and_return(double("result", success: true))
  end

  pactflow
  include_context "pact broker"
  include_context "pact broker - pact-ruby-v2"
  include PactBrokerPactHelperMethods

  let(:command_params) do
    {
      provider_name: "Bar",
      provider_version_number: "1",
      branch_name: "main",
      tags: ["dev"],
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

  let(:body) { { some: "body" }.to_json }

  let(:request_body) do
     {
        "content" => "LS0tCnNvbWU6IGNvbnRyYWN0Cg==",
        "contractType" => "oas",
        "contentType" => "application/yaml",
        "verificationResults" => {
          "success" => true,
          "content" => "c29tZSByZXN1bHRz",
          "contentType" => "text/plain",
          "format" => "text",
          "verifier" => "my custom tool",
          "verifierVersion" => "1.0"
        }
     }
  end

  let(:response_status) { 201 }
  let(:success_response) do
    {
      status: response_status,
      headers: pact_broker_response_headers
    }
  end

  let(:options) do
    {
      verbose: false
    }
  end

  let(:pactflow_mock_service_base_url) { "http://127.0.0.1:9998" }

  let(:pact_broker_client_options) do
    { pact_broker_base_url: pactflow_mock_service_base_url }
  end


  subject { Pactflow::Client::ProviderContracts::PublishTheOldWay.call(command_params, options, pact_broker_client_options) }

  context "creating a provider contract with valid parameters" do
    let(:interaction) do
      new_interaction
        .upon_receiving("a request to create a provider contract")
        .with_request(
            method: :put,
            path: "/contracts/provider/Bar/version/1",
            headers: put_request_headers,
            body: request_body)
        .will_respond_with(**success_response)
    end

    it "returns a CommandResult with success = true" do
      interaction.execute do |mock_server|
        expect(subject).to be_a PactBroker::Client::CommandResult
        expect(subject.success).to be true
        expect(subject.message).to include "Successfully published provider contract for Bar version 1"
        expect(subject.message).not_to include pactflow_mock_service_base_url
      end
    end
  end

  context "creating a provider contract with valid parameters with pf:ui return results" do
    let(:success_response_with_pf_ui_url) do
      {
        status: response_status,
        headers: pact_broker_response_headers,
        body: { "_links": {
          "pf:ui": {
            "href": match_type_of("some-url")
          }
        } }
      }
    end
    let(:interaction) do
      new_interaction
        .given("there is a pf:ui href in the response")
        .upon_receiving("a request to create a provider contract")
        .with_request(
          method: :put,
          path: "/contracts/provider/Bar/version/1",
          headers: put_request_headers,
          body: request_body
        )
        .will_respond_with(**success_response_with_pf_ui_url)
    end

    it "returns a CommandResult with success = true and a provider contract ui url" do
      interaction.execute do |mock_server|
        expect(subject).to be_a PactBroker::Client::CommandResult
        expect(subject.success).to be true
        expect(subject.message).to include "Successfully published provider contract for Bar version 1"
        expect(subject.message).to include "Next steps:"
        expect(subject.message).to include "some-url"
      end
    end
  end
end
