require "yaml"
require_relative "pact_helper"
require "pactflow/client/provider_contracts/publish"

RSpec.describe "publishing a provider contract to PactFlow", pact: true do
  include_context "pact broker"
  include PactBrokerPactHelperMethods

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

  let(:body) { { some: "body" }.to_json }

  let(:request_body) do
     {
      "pacticipantVersionNumber" => "1",
      "tags" => ["dev"],
      "branch" => "main",
      "buildUrl" => "http://build",
      "contract" => {
        "content" => "LS0tCnNvbWU6IGNvbnRyYWN0Cg==",
        "contentType" => "application/yaml",
        "specification" => "oas",
        "verificationResults" => {
          "success" => true,
          "content" => "c29tZSByZXN1bHRz",
          "contentType" => "text/plain",
          "format" => "text",
          "verifier" => "my custom tool",
          "verifierVersion" => "1.0"
        }
      }
     }
  end

  let(:response_status) { 200 }
  let(:success_response) do
    {
      status: response_status,
      headers: pact_broker_response_headers,
      body: {
        "notices" => Pact.each_like("text" => "some notice", "type" => "info")
      }
    }
  end

  let(:options) do
    {
      verbose: false
    }
  end

  let(:pact_broker_client_options) do
    { pact_broker_base_url: pactflow.mock_service_base_url }
  end

  subject { Pactflow::Client::ProviderContracts::Publish.call(command_params, options, pact_broker_client_options) }

  context "creating a provider contract with valid parameters" do
    before do
      pactflow
        .given("the pb:publish-provider-contract relation exists in the index resource")
        .upon_receiving("a request for the index resource")
        .with(
            method: "GET",
            path: "/",
            headers: get_request_headers
        ).will_respond_with(
          status: 200,
          headers: pact_broker_response_headers,
          body: {
            _links: {
              :'pf:publish-provider-contract' => {
                href: placeholder_url_term("pf:publish-provider-contract", ['provider'], pactflow)
              }
            }
          }
        )

      pactflow
        .upon_receiving("a request to publish a provider contract")
        .with(
            method: :post,
            path: placeholder_path("pf:publish-provider-contract", ["Bar"]),
            headers: post_request_headers,
            body: request_body
        ).will_respond_with(success_response)
    end

    it "returns a CommandResult with success = true" do
      expect(subject).to be_a PactBroker::Client::CommandResult
      expect(subject.success).to be true
      expect(subject.message).to include "some notice"
    end
  end
end
