require_relative '../../../pact_ruby_v2_spec_helper'
require 'pact_broker/client/deployments/record_deployment'

RSpec.describe "recording a deployment", pact: true do
  pact_broker
  include_context "pact broker"
  include_context "pact broker - pact-ruby-v2"
  include PactBrokerPactHelperMethods

  let(:pacticipant_name) { "Foo" }
  let(:version_number) { "5556b8149bf8bac76bc30f50a8a2dd4c22c85f30" }
  let(:environment_name) { "test" }
  let(:output) { "text" }
  let(:application_instance) { "blue" }
  let(:params) do
    {
      pacticipant_name: pacticipant_name,
      version_number: version_number,
      environment_name: environment_name,
      application_instance: application_instance
    }
  end
  let(:options) do
    {
      output: output
    }
  end

  let(:pact_broker_base_url) { "http://127.0.0.1:9999" }
  let(:pact_broker_client_options) { { pact_broker_base_url: pact_broker_base_url } }

  subject { PactBroker::Client::Deployments::RecordDeployment.call(params, options, pact_broker_client_options) }

  def mock_index
    new_interaction
      .given("the pb:pacticipant-version and pb:environments relations exist in the index resource")
      .upon_receiving("a request for the index resource")
      .with_request(
          method: "GET",
          path: '/',
          headers: get_request_headers).
        will_respond_with(
          status: 200,
          headers: pact_broker_response_headers,
          body: {
            _links: {
              :'pb:pacticipant-version' => {
                href: placeholder_url_term("pb:pacticipant-version", ["pacticipant", "version"], pact_broker_base_url)
              },
              :'pb:environments' => {
                href: placeholder_url_term("pb:environments", [], pact_broker_base_url)
              }
            }
          }
        )
  end

  def mock_pacticipant_version_with_test_environment_available_for_deployment
    new_interaction
      .given("version 5556b8149bf8bac76bc30f50a8a2dd4c22c85f30 of pacticipant Foo exists with a test environment available for deployment")
      .upon_receiving("a request for a pacticipant version")
      .with_request(
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
                href: placeholder_url_term("pb:record-deployment-#{pacticipant_name}-#{version_number}-#{environment_name}", [], pact_broker_base_url)
              }
            ]
          }
        }
      )
  end

  def mock_pacticipant_version_without_test_environment_available_for_deployment
    new_interaction
      .given("version 5556b8149bf8bac76bc30f50a8a2dd4c22c85f30 of pacticipant Foo exists with 2 environments that aren't test available for deployment")
      .upon_receiving("a request for a pacticipant version")
      .with_request(
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
              match_type_of(
                name: "prod",
                href: "href"
              ),
              match_type_of(
                name: "dev",
                href: "href"
              ),
            ]
          }
        }
      )
  end

  def mock_environments
    new_interaction
      .given("an environment with name test exists")
      .upon_receiving("a request for the environments")
      .with_request(
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
                href: match_type_of("href")
              }
            ]
          }
        }
      )
  end

  def mock_record_deployment
    new_interaction
      .given("version 5556b8149bf8bac76bc30f50a8a2dd4c22c85f30 of pacticipant Foo exists with a test environment available for deployment")
      .upon_receiving("a request to record a deployment")
      .with_request(
        method: "POST",
        path: "/HAL-REL-PLACEHOLDER-PB-RECORD-DEPLOYMENT-FOO-5556B8149BF8BAC76BC30F50A8A2DD4C22C85F30-TEST",
        headers: post_request_headers,
        body: {
          applicationInstance: application_instance,
          target: application_instance
        }
      )
      .will_respond_with(
        status: 201,
        headers: pact_broker_response_headers,
        body: {
          target: application_instance
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
      execute_http_pact do | mockserver |
        expect(subject.success).to be true
        expect(subject.message).to include "Recorded deployment of Foo version 5556b8149bf8bac76bc30f50a8a2dd4c22c85f30 to test environment (application instance blue) in the Pact Broker."
      end 
    end

    context "when the output is json" do
      let(:output) { "json" }

      it "returns the JSON payload" do
        execute_http_pact do | mockserver |
          expect(JSON.parse(subject.message)).to eq "target" => application_instance
        end
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
        execute_http_pact do | mockserver |
          expect(subject.success).to be false
          expect(subject.message).to include "No environment found"
        end
      end
    end

    context "when the specified environment does exist" do
      it "returns an error response" do
        execute_http_pact do | mockserver |
          expect(subject.success).to be false
          expect(subject.message).to include "not an available option"
        end
      end
    end
  end
end
