require_relative 'pact_helper'
require 'pact_broker/client'
require 'pact_broker/client/publish_pacts'

describe PactBroker::Client::Versions, pact: true do

  include_context "pact broker"


  describe "creating a pacticipant version" do
    before do
      allow(publish_pacts).to receive(:consumer_names).and_return(["Foo"])
      allow($stdout).to receive(:puts)
    end
    let(:version_path) { "/HAL-REL-PLACEHOLDER-INDEX-PB-PACTICIPANT-VERSION-{pacticipant}-{version}" }
    let(:version_url) { pact_broker.mock_service_base_url + version_path }
    let(:number) { "26f353580936ad3b9baddb17b00e84f33c69e7cb" }
    let(:branch) { "main" }
    let(:build_url) { "http://my-ci/builds/1" }
    let(:consumer_version_params) { { number: number, branch: branch, build_url: build_url } }
    let(:publish_pacts) { PactBroker::Client::PublishPacts.new(pact_broker.mock_service_base_url, ["some-pact.json"], consumer_version_params, {}) }
    let(:provider_state) { "version #{number} of pacticipant Foo does not exist" }
    let(:expected_response_status) { 201 }

    subject { publish_pacts.send(:create_consumer_versions) }

    before do
      pact_broker
        .given("the pb:pacticipant-version relation exists in the index resource")
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
                :'pb:pacticipant-version' => {
                  href: Pact.term(version_url, /http:\/\/.*{pacticipant}.*{version}/)
                }
              }
            }
          )

      pact_broker
        .given(provider_state)
        .upon_receiving("a request to create a pacticipant version")
        .with(
            method: :patch,
            path: "/HAL-REL-PLACEHOLDER-INDEX-PB-PACTICIPANT-VERSION-Foo-#{number}",
            headers: patch_request_headers,
            body: {
              branch: branch,
              buildUrl: build_url
            }).
          will_respond_with(
            status: expected_response_status,
            headers: pact_broker_response_headers,
            body: {
              number: number,
              branch: branch,
              buildUrl: build_url,
              _links: {
                self: {
                  href: Pact.term('http://localhost:1234/some-url', %r{http://.*})
                }
              }
            }
          )
    end

    context "when the version does not already exist" do
      it "returns true" do
        expect(subject).to be true
      end
    end

    context "when the version does exist" do
      let(:provider_state) { "version #{number} of pacticipant Foo does exist" }
      let(:expected_response_status) { 200 }

      it "returns true" do
        expect(subject).to be true
      end
    end
  end
end
