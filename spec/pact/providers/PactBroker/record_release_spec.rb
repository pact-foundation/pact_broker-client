require_relative '../../../pact_ruby_v2_spec_helper'
require 'pact_broker/client/deployments/record_deployment'

RSpec.describe "recording a release", pact: true do
  pact_broker
  include_context "pact broker"
  include_context "pact broker - pact-ruby-v2"
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

  let(:pact_broker_base_url) { "http://127.0.0.1:9999" }
  let(:pact_broker_client_options) { { pact_broker_base_url: pact_broker_base_url } }

  subject { PactBroker::Client::Deployments::RecordRelease.call(params, options, pact_broker_client_options) }

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
                href: generate_mock_server_url(
                  regex: ".*(\\/pacticipants\\/.*\\/versions\\/.*)$",
                  example: "/pacticipants/{pacticipant}/versions/{version}"
                ),
              },
              :'pb:environments' => {
                href: generate_mock_server_url(
                  regex: ".*(\\/environments)$",
                  example: "/environments"
                )
              }
            }
          }
        )
  end

  def mock_pacticipant_version_with_test_environment_available_for_release
    new_interaction
      .given("version 5556b8149bf8bac76bc30f50a8a2dd4c22c85f30 of pacticipant Foo exists with a test environment available for release")
      .upon_receiving("a request for a pacticipant version")
      .with_request(
        method: "GET",
        path: "/pacticipants/Foo/versions/5556b8149bf8bac76bc30f50a8a2dd4c22c85f30",
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
                href: generate_mock_server_url(
                  regex: ".*(\\/pacticipants\\/.*\\/versions\\/.*\\/released-versions\\/environment\\/.*)$",
                  example: "/pacticipants/#{pacticipant_name}/versions/#{version_number}/released-versions/environment/cb632df3-0a0d-4227-aac3-60114dd36479"
                ),
              }
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
        path: "/environments",
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
                href: generate_mock_server_url(
                  regex: ".*(\\/environments\\/.*)$",
                  example: "/environments/cb632df3-0a0d-4227-aac3-60114dd36479"
                )
              }
            ]
          }
        }
      )
  end

  def mock_record_release
    new_interaction
      .given("version 5556b8149bf8bac76bc30f50a8a2dd4c22c85f30 of pacticipant Foo exists with a test environment available for deployment")
      .upon_receiving("a request to record a release")
      .with_request(
        method: "POST",
        path: "/pacticipants/Foo/versions/5556b8149bf8bac76bc30f50a8a2dd4c22c85f30/released-versions/environment/cb632df3-0a0d-4227-aac3-60114dd36479",
        headers: post_request_headers,
        body: {}
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
      execute_http_pact do | mockserver |
        expect(subject.success).to be true
        expect(subject.message).to include "Recorded release of Foo version 5556b8149bf8bac76bc30f50a8a2dd4c22c85f30 to test environment in the Pact Broker."
      end
    end
  end
end
