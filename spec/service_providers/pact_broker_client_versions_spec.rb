require 'spec_helper'
require 'pact_broker/client'
require_relative 'pact_helper'

describe PactBroker::Client::Versions, pact: true do

  include_context "pact broker"

  let(:get_headers) { { "Accept" => "application/hal+json, application/json" } }

  describe "retrieving the latest pacticipant version" do
    let(:latest_version_path) { "/HAL-REL-PLACEHOLDER-INDEX-PB-LATEST-VERSION-{pacticipant}" }
    let(:latest_version_url) { pact_broker.mock_service_base_url + latest_version_path }

    before do
      pact_broker
        .given("the pb:latest-version relation exists in the index resource")
        .upon_receiving("a request for the index resource")
        .with(
            method: :get,
            path: '/',
            headers: get_headers).
          will_respond_with(
            status: 200,
            headers: pact_broker_response_headers,
            body: {
              _links: {
                :'pb:latest-version' => {
                  href: Pact.term(latest_version_url, /http:\/\/.*{pacticipant}/)
                }
              }
            }
          )

      pact_broker
        .given("'Condor' exists in the pact-broker with the latest version 1.2.3")
        .upon_receiving("a request to retrieve the latest version of Condor")
        .with(
            method: :get,
            path: '/HAL-REL-PLACEHOLDER-INDEX-PB-LATEST-VERSION-Condor',
            headers: get_headers).
          will_respond_with(
            status: 200,
            headers: pact_broker_response_headers,
            body: {
              number: '1.2.3',
              _links: {
                self: {
                  href: Pact.term('http://localhost:1234/some-url', %r{http://.*})
                }
              }
            }
          )
    end

    it "returns the version hash" do
      version_hash = pact_broker_client.pacticipants.versions.latest(pacticipant: 'Condor')
      expect(version_hash[:number]).to eq '1.2.3'
      expect(version_hash[:_links][:self][:href]).to eq 'http://localhost:1234/some-url'
    end
  end

  describe "retrieving the latest pacticipant version for a tag" do
    let(:latest_tagged_version_path) { "/HAL-REL-PLACEHOLDER-INDEX-PB-LATEST-TAGGED-VERSION-{pacticipant}-{tag}" }
    let(:latest_tagged_version_url) { pact_broker.mock_service_base_url + latest_tagged_version_path }

    before do
      pact_broker
        .given("the pb:latest-tagged-version relation exists in the index resource")
        .upon_receiving("a request for the index resource")
        .with(
            method: :get,
            path: '/',
            headers: get_headers).
          will_respond_with(
            status: 200,
            headers: pact_broker_response_headers,
            body: {
              _links: {
                :'pb:latest-tagged-version' => {
                  href: Pact.term(latest_tagged_version_url, /http:\/\/.*{pacticipant}.*{tag}/)
                }
              }
            }
          )

      pact_broker
        .given("'Condor' exists in the pact-broker with the latest tagged 'production' version 1.2.3")
        .upon_receiving("a request to retrieve the latest 'production' version of Condor")
        .with(
            method: :get,
            path: '/HAL-REL-PLACEHOLDER-INDEX-PB-LATEST-TAGGED-VERSION-Condor-production',
            headers: get_headers).
          will_respond_with(
            status: 200,
            headers: pact_broker_response_headers,
            body: {
              number: '1.2.3',
              _links: {
                self: {
                  href: Pact.term('http://localhost:1234/some-url', %r{http://.*})
                }
              }
            }
          )
    end

    it "returns the version hash" do
      version_hash = pact_broker_client.pacticipants.versions.latest(pacticipant: 'Condor', tag: 'production')
      expect(version_hash[:number]).to eq '1.2.3'
      expect(version_hash[:_links][:self][:href]).to eq 'http://localhost:1234/some-url'
    end
  end
end