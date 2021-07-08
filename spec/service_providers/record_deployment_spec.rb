require 'service_providers/pact_helper'
require 'pact_broker/client/deployments/record_deployment'

RSpec.describe "recording a deployment", pact: true do
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
      environment_name: environment_name,
      target: target
    }
  end
  let(:options) do
    {
      output: output
    }
  end
  let(:pact_broker_client_options) { { pact_broker_base_url: broker_base_url } }

  subject { PactBroker::Client::Deployments::RecordDeployment.call(params, options, pact_broker_client_options) }

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

  def mock_pacticipant_version_with_test_environment_available_for_deployment
    pact_broker
      .given("version 5556b8149bf8bac76bc30f50a8a2dd4c22c85f30 of pacticipant Foo exists with a test environment available for deployment")
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
            "pb:record-deployment" => [
              {
                name: "test",
                href: placeholder_url_term("pb:record-deployment-#{pacticipant_name}-#{version_number}-#{environment_name}")
              }
            ]
          }
        }
      )
  end

  def mock_pacticipant_version_without_test_environment_available_for_deployment
    pact_broker
      .given("version 5556b8149bf8bac76bc30f50a8a2dd4c22c85f30 of pacticipant Foo exists with 2 environments that aren't test available for deployment")
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
            "pb:record-deployment" => [
              Pact.like(
                name: "prod",
                href: "href"
              ),
              Pact.like(
                name: "dev",
                href: "href"
              ),
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

  def mock_record_deployment
    pact_broker
      .given("version 5556b8149bf8bac76bc30f50a8a2dd4c22c85f30 of pacticipant Foo exists with a test environment available for deployment")
      .upon_receiving("a request to record a deployment")
      .with(
        method: "POST",
        path: "/HAL-REL-PLACEHOLDER-PB-RECORD-DEPLOYMENT-FOO-5556B8149BF8BAC76BC30F50A8A2DD4C22C85F30-TEST",
        headers: post_request_headers,
        body: {
          target: target
        }
      )
      .will_respond_with(
        status: 201,
        headers: pact_broker_response_headers,
        body: {
          target: target
        }
      )
  end

  context "when the deployment is recorded successfully" do
    before do
      mock_index
      mock_pacticipant_version_with_test_environment_available_for_deployment
      mock_record_deployment
    end

    it "returns a success message" do
      expect(subject.success).to be true
      expect(subject.message).to include "Recorded deployment of Foo version 5556b8149bf8bac76bc30f50a8a2dd4c22c85f30 to test environment (target blue) in the Pact Broker."
    end

    context "when the output is json" do
      let(:output) { "json" }

      it "returns the JSON payload" do
        expect(JSON.parse(subject.message)).to eq "target" => target
      end
    end
  end

  context "when the specified environment is not available for recording a deployment" do
    before do
      mock_index
      mock_pacticipant_version_without_test_environment_available_for_deployment
      mock_environments
    end

    context "when the specified environment does not exist" do
      let(:environment_name) { "foo" }

      it "returns an error response" do
        expect(subject.success).to be false
        expect(subject.message).to include "No environment found"
      end
    end

    context "when the specified environment does exist" do
      it "returns an error response" do
        expect(subject.success).to be false
        expect(subject.message).to include "not an available option"
      end
    end
  end
end
