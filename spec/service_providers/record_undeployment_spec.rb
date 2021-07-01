require 'service_providers/pact_helper'
require 'pact_broker/client/deployments/record_undeployment'

deployment_feature_on = ENV.fetch('PACT_BROKER_FEATURES', '').include?("deployments")

RSpec.describe "recording an undeployment", pact: true, skip: !deployment_feature_on do
  include_context "pact broker"
  include PactBrokerPactHelperMethods

  let(:pacticipant_name) { "Foo" }
  let(:environment_name) { "test" }
  let(:output) { "text" }
  let(:target) { "customer-1" }
  let(:params) do
    {
      pacticipant_name: pacticipant_name,
      environment_name: environment_name,
      target: target
    }
  end
  let(:options) do
    {
      output: output,
      verbose: true
    }
  end
  let(:webmock_base_url) { "http://broker" }
  let(:pact_broker_client_options) { { pact_broker_base_url: webmock_base_url } }
  let(:test_environment_placeholder_path) { "/HAL-REL-PLACEHOLDER-PB-ENVIRONMENT-16926ef3-590f-4e3f-838e-719717aa88c9" }
  let(:currently_deployed_versions_placeholder_path) { "/PLACEHOLDER-ENVIRONMENT-CURRENTLY-DEPLOYED-16926ef3-590f-4e3f-838e-719717aa88c9" }
  let(:deployed_version_placeholder_path) { "/PLACEHOLDER-DEPLOYED-VERSION-ff3adecf-cfc5-4653-a4e3-f1861092f8e0"}

  subject { PactBroker::Client::Deployments::RecordUndeployment.call(params, options, pact_broker_client_options) }

  let(:index_body_hash) do
    {
      _links: {
        :'pb:environments' => {
          href: "#{webmock_base_url}/environments"
        }
      }
    }
  end

  let(:environments_hash) do
    {
      _links: {
        :'pb:environments' => [
          {
            name: "test",
            href: pact_broker.mock_service_base_url + test_environment_placeholder_path
          }
        ]
      }
    }
  end

  let!(:index_request) do
    stub_request(:get, "http://broker").to_return(status: 200, body: index_body_hash.to_json, headers: { "Content-Type" => "application/hal+json" }  )
  end

  let!(:environments_request) do
    stub_request(:get, "http://broker/environments").to_return(status: 200, body: environments_hash.to_json, headers: { "Content-Type" => "application/hal+json" }  )
  end

  def mock_test_environment
    pact_broker
      .given("an environment with name test and UUID 16926ef3-590f-4e3f-838e-719717aa88c9 exists")
      .upon_receiving("a request for an environment")
      .with(
        method: "GET",
        path: test_environment_placeholder_path,
        headers: get_request_headers
      )
      .will_respond_with(
        status: 200,
        headers: pact_broker_response_headers,
        body: {
          _links: {
            :'pb:currently-deployed-deployed-versions' => {
              href: Pact.term( pact_broker.mock_service_base_url + currently_deployed_versions_placeholder_path, /^http.*/)
            }
          }
        }
      )
  end

  def mock_deployed_versions_search_results
    pact_broker
      .given("an version is deployed to environment with UUID 16926ef3-590f-4e3f-838e-719717aa88c9 with target customer-1")
      .upon_receiving("a request to list the versions deployed to an environment for a pacticipant name and target")
      .with(
        method: "GET",
        path: currently_deployed_versions_placeholder_path,
        query: { pacticipant: pacticipant_name },
        headers: get_request_headers
      )
      .will_respond_with(
        status: 200,
        headers: pact_broker_response_headers,
        body: {
          _embedded: {
            deployedVersions: [
              {
                target: target,
                _links: {
                  self: {
                    href: Pact.term(pact_broker.mock_service_base_url + deployed_version_placeholder_path, /^http/)
                  }
                }
              }
            ]
          }
        }
      )
  end

  def mock_mark_deployed_version_as_undeployed
    pact_broker
      .given("a currently deployed version exists")
      .upon_receiving("a request to mark a deployed version as not currently deploye")
      .with(
        method: "PATCH",
        path: deployed_version_placeholder_path,
        body: { currentlyDeployed: false },
        headers: patch_request_headers
      )
      .will_respond_with(
        status: 200,
        headers: pact_broker_response_headers,
        body: deployed_version_hash
      )
  end

  let(:deployed_version_hash) do
    {
      "currentlyDeployed" => false,
      "_embedded" => {
        "version" => {
          "number" => Pact.like("2")
        }
      }
    }
  end

  context "when the deployment is recorded successfully" do
    before do
      mock_test_environment
      mock_deployed_versions_search_results
      mock_mark_deployed_version_as_undeployed
    end

    it "returns a success message" do
      expect(subject.success).to be true
      expect(subject.message).to include "Recorded undeployment of Foo version 2 from test environment (target customer-1) in the Pact Broker"
    end

    context "when the output is json" do
      let(:output) { "json" }

      it "returns the JSON payload" do
        expect(JSON.parse(subject.message)).to eq [Pact::Reification.from_term(deployed_version_hash)]
      end
    end
  end
end
