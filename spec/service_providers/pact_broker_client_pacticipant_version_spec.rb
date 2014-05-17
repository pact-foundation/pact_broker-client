require_relative 'pact_helper'
require 'pact_broker/client'

module PactBroker::Client
  describe Pacts, :pact => true do

    include_context "pact broker"

    describe "retriving pacticipant versions" do
      context "when retrieving the production details of a version" do
        context "when a version is found" do
          let(:repository_ref) { "package/pricing-service-1.2.3"}
          let(:tags) { ['prod']}
          let(:body) { { number: '1.2.3', repository_ref: repository_ref, tags: tags } }
          before do
            pact_broker.
              given("a pacticipant version with production details exists for the Pricing Service").
              upon_receiving("a request for the latest pacticpant version tagged with 'prod'").
              with(
                method: :get,
                path: '/pacticipants/Pricing%20Service/versions/latest',
                query: 'tag=prod',
                headers: get_request_headers).
              will_respond_with(
                status: 200,
                headers: pact_broker_response_headers.merge({'Content-Type' => 'application/json'}),
                body: body )
          end

          xit 'returns the version details' do
            expect( pact_broker_client.pacticipants.versions.latest pacticipant: 'Pricing Service', tag: 'prod' ).to eq body
          end
        end
      end
      context "when a version is not found" do
        before do
          pact_broker.
            given("no pacticipant version exists for the Pricing Service").
            upon_receiving("a request for the latest pacticipant version").
            with(
              method: :get,
              path: '/pacticipants/Pricing%20Service/versions/latest',
              headers: get_request_headers).
            will_respond_with(
              status: 404,
              headers: pact_broker_response_headers )
        end

        xit 'returns nil' do
          expect( pact_broker_client.pacticipants.versions.latest pacticipant: 'Pricing Service' ).to eq nil
        end
      end
    end

  end
end
