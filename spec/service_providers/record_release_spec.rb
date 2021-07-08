require 'service_providers/pact_helper'
require 'pact_broker/client/deployments/record_deployment'

RSpec.describe "recording a release", pact: true do
  include_context "pact broker"
  include PactBrokerPactHelperMethods

  let(:pacticipant_name) { "Foo" }
  let(:version_number) { "5556b8149bf8bac76bc30f50a8a2dd4c22c85f30" }
  let(:environment_name) { "test" }
  let(:output) { "text" }
  let(:target) { "blue" }
  let(:params) do
    {
      pacticipant_name: pacticipant_name,
      version_number: version_number,
      environment_name: environment_name
    }
  end
  let(:options) do
    {
      output: output
    }
  end
  let(:pact_broker_client_options) { { pact_broker_base_url: broker_base_url } }

  subject { PactBroker::Client::Deployments::RecordRelease.call(params, options, pact_broker_client_options) }

  def mock_index
    pact_broker
      .given("the pb:pacticipant-version and pb:environments relations exist in the index resource")
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
              :'pb:pacticipant-version' => {
                href: placeholder_url_term("pb:pacticipant-version", ["pacticipant", "version"])
              },
              :'pb:environments' => {
                href: placeholder_url_term("pb:environments")
              }
            }
          }
        )
  end

  def mock_pacticipant_version_with_test_environment_available_for_release
    pact_broker
      .given("version 5556b8149bf8bac76bc30f50a8a2dd4c22c85f30 of pacticipant Foo exists with a test environment available for release")
      .upon_receiving("a request for a pacticipant version")
      .with(
        method: "GET",
        path: "/HAL-REL-PLACEHOLDER-PB-PACTICIPANT-VERSION-Foo-5556b8149bf8bac76bc30f50a8a2dd4c22c85f30",
        headers: get_request_headers
      )
      .will_respond_with(
        status: 200,
        headers: pact_broker_response_headers,
        body: {
          _links: {
            "pb:record-release" => [
              {
                name: "test",
                href: placeholder_url_term("pb:record-release-#{pacticipant_name}-#{version_number}-#{environment_name}")
              }
            ]
          }
        }
      )
  end

  def mock_environments
    pact_broker
      .given("an environment with name test exists")
      .upon_receiving("a request for the environments")
      .with(
        method: "GET",
        path: "/HAL-REL-PLACEHOLDER-PB-ENVIRONMENTS",
        headers: get_request_headers
      )
      .will_respond_with(
        status: 200,
        headers: pact_broker_response_headers,
        body: {
          _links: {
            "pb:environments" => [
              {
                name: "test",
                href: Pact.like("href")
              }
            ]
          }
        }
      )
  end

  def mock_record_release
    pact_broker
      .given("version 5556b8149bf8bac76bc30f50a8a2dd4c22c85f30 of pacticipant Foo exists with a test environment available for deployment")
      .upon_receiving("a request to record a release")
      .with(
        method: "POST",
        path: "/HAL-REL-PLACEHOLDER-PB-RECORD-RELEASE-FOO-5556B8149BF8BAC76BC30F50A8A2DD4C22C85F30-TEST",
        headers: post_request_headers
      )
      .will_respond_with(
        status: 201,
        headers: pact_broker_response_headers
      )
  end

  context "when the deployment is recorded successfully" do
    before do
      mock_index
      mock_pacticipant_version_with_test_environment_available_for_release
      mock_record_release
    end

    it "returns a success message" do
      expect(subject.success).to be true
      expect(subject.message).to include "Recorded release of Foo version 5556b8149bf8bac76bc30f50a8a2dd4c22c85f30 to test environment in the Pact Broker."
    end
  end
end
