require 'spec_helper'
require 'pact_broker/client'
require_relative 'pact_helper'

describe PactBroker::Client::Versions, pact: true do

  include_context "pact broker"

  describe "adding an environment to a version" do

    let(:environment_options) { {pacticipant: 'Condor', version: version, :environment => 'production'} }
    let(:pacticipant_version_placeholder_path) { "/HAL-REL-PLACEHOLDER-INDEX-PB-PACTICIPANT-VERSION-ENVIRONMENT-{pacticipant}-{version}-{environment}" }
    let(:pacticipant_version_placeholder_url) { pact_broker.mock_service_base_url + pacticipant_version_placeholder_path }

    before do
      pact_broker
        .given("the pb:pacticipant-version-environment relation exists in the index resource")
        .upon_receiving("a request for the index resource")
        .with(
            method: :get,
            path: '/',
            headers: get_request_headers).
          will_respond_with(
            status: 200,
            headers: pact_broker_response_headers,
            body: {
              _links: {
                :'pb:pacticipant-version-environment' => {
                  href: Pact.term(pacticipant_version_placeholder_url, /http:\/\/.*{pacticipant}.*{version}.*{environment}/)
                }
              }
            }
          )
    end

    context "when the pacticipant and version exist" do
      before do
        pact_broker.
        given("'Condor' exists in the pact-broker with version 1.3.0").
        upon_receiving("a request to add an environment a version of Condor").
        with(
            method: :put,
            path: '/HAL-REL-PLACEHOLDER-INDEX-PB-PACTICIPANT-VERSION-ENVIRONMENT-Condor-1.3.0-production',
            headers: put_request_headers).
          will_respond_with(
            status: 201,
            headers: pact_broker_response_headers,
            body: {
              name: "production",
              _links: {
                self: {
                  href:
                  Pact::Term.new(
                    generate: 'http://environment-url',
                    matcher: %r{http://.*})
                }
              }
            }
          )
      end

      it "returns true" do
        expect(pact_broker_client.pacticipants.versions.add_environment environment_options).to be true
      end
    end

    context "when the pacticipant exists, but not the version" do
      before do
        pact_broker.
        given("'Condor' exists in the pact-broker").
        upon_receiving("a request to add an environment a version of Condor").
        with(
            method: :put,
            path: '/HAL-REL-PLACEHOLDER-INDEX-PB-PACTICIPANT-VERSION-ENVIRONMENT-Condor-1.3.0-production',
            headers: default_request_headers).
          will_respond_with(
            status: 404
          )
      end

      it "returns false" do
        expect(pact_broker_client.pacticipants.versions.add_environment environment_options).to be false
      end
    end
  end
end