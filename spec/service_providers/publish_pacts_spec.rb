require 'pact_broker/client/publish_pacts'
require 'service_providers/pact_helper'

RSpec.describe "publishing contracts", pact: true do
  before do
    allow_any_instance_of(PactBroker::Client::Hal::HttpClient).to receive(:sleep)
    allow_any_instance_of(PactBroker::Client::Hal::HttpClient).to receive(:default_max_tries).and_return(1)
  end
  include_context "pact broker"
  include PactBrokerPactHelperMethods

  let(:pacticipant_name) { "Foo" }
  let(:version_number) { "5556b8149bf8bac76bc30f50a8a2dd4c22c85f30" }
  let(:output) { "text" }
  let(:build_url) { "http://build" }
  let(:consumer_version_params) do
    {
      pacticipant_name: pacticipant_name,
      number: version_number,
      tags: ["dev"],
      branch: "main",
      build_url: build_url,
      output: output
    }
  end
  let(:pact_file_path_1) { "spec/fixtures/foo-bar.json" }
  let(:pact_file_paths) { [pact_file_path_1] }
  let(:options) { {} }
  let(:pact_broker_client_options) { {} }
  let(:expected_content) { Base64.strict_encode64(JSON.parse(File.read(pact_file_path_1)).to_json) }
  let(:request_body) do
    {
      pacticipantName: pacticipant_name,
      pacticipantVersionNumber: version_number,
      branch: "main",
      tags: ["dev"],
      buildUrl: "http://build",
      contracts: [
        {
          consumerName: pacticipant_name,
          providerName: "Bar",
          specification: "pact",
          contentType: "application/json",
          content: expected_content,
          writeMode: "overwrite",
          onConflict: "overwrite"
        }
      ]
    }
  end

  subject { PactBroker::Client::PublishPacts.call(broker_base_url, pact_file_paths, consumer_version_params, options, pact_broker_client_options) }

  def mock_index
    pact_broker
      .given("the pb:publish-contracts relations exists in the index resource")
      .upon_receiving("a request for the index resource")
      .with(
          method: "GET",
          path: '/',
          headers: get_request_headers).
        will_respond_with(
          status: 200,
          headers: pact_broker_response_headers,
          body: {
            _links: {
              :'pb:publish-contracts' => {
                href: placeholder_url_term("pb:publish-contracts")
              }
            }
          }
        )
  end

  def mock_contract_publication
    pact_broker
      .upon_receiving("a request to publish contracts")
      .with(
          method: "POST",
          path: '/HAL-REL-PLACEHOLDER-PB-PUBLISH-CONTRACTS',
          headers: post_request_headers,
          body: request_body).
        will_respond_with(
          status: 200,
          headers: pact_broker_response_headers,
          body: {
            _embedded: {
              pacticipant: {
                name: pacticipant_name
              },
              version: {
                number: version_number,
                buildUrl: build_url
              }
            },
            logs: Pact.each_like(level: "info", message: "some message"),
            _links: {
              :'pb:pacticipant-version-tags' => [{ name: "dev"} ],
              :'pb:contracts' => [{ href: Pact.like("http://some-pact") }]
            }
          }
        )
  end

  context "with valid params" do
    before do
      mock_index
      mock_contract_publication
    end

    it "returns a success result" do
      expect(subject.success).to be true
      expect(subject.message).to include "some message"
    end
  end
end
