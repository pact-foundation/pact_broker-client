require_relative 'pact_helper'
require 'pact_broker/client'

module PactBroker::Client
  describe Pacts, :pact => true do

    include_context "pact broker"

    describe "retrieving a pact" do
      describe "retriving a specific version" do
        before do
          pact_broker.
            given("the 'Pricing Service' and 'Condor' already exist in the pact-broker, and Condor already has a pact published for version 1.3.0").
            upon_receiving("a request retrieve a pact for a specific version").
            with(
              method: :get,
              path: '/pact/provider/Pricing%20Service/consumer/Condor/version/1.3.0',
              headers: {} ).
            will_respond_with(
              headers: pact_broker_response_headers,
              status: 200,
              body: pact_hash
            )
        end
        it "returns the pact json" do
          response = pact_broker_client.pacticipants.versions.pacts.get consumer: 'Condor', provider: 'Pricing Service', consumer_version: '1.3.0'
          expect(response).to eq(pact_json)
        end
      end

      describe "finding the latest version" do
        context "when a pact is found" do

          let(:response_headers) { pact_broker_response_headers.merge({'Content-Type' => 'application/json', 'X-Pact-Consumer-Version' => consumer_version}) }
          before do
            pact_broker.
              given("a pact between Condor and the Pricing Service exists").
              upon_receiving("a request to retrieve the latest pact between Condor and the Pricing Service").
              with(
                method: :get,
                path: '/pact/provider/Pricing%20Service/consumer/Condor/latest',
                headers: {}
              ).
              will_respond_with(
                status: 200,
                headers: response_headers,
                body: pact_hash
              )
          end

          it "returns the pact json" do
            response = pact_broker_client.pacticipants.versions.pacts.latest consumer: 'Condor', provider: 'Pricing Service'
            expect(response).to eq(pact_json)
          end

        end
        context "when no pact is found" do
          before do
            pact_broker.
              given("no pact between Condor and the Pricing Service exists").
              upon_receiving("a request to retrieve the latest pact between Condor and the Pricing Service").
              with(
                method: :get,
                path: '/pact/provider/Pricing%20Service/consumer/Condor/latest',
                headers: {}
              ).
              will_respond_with(
                status: 404,
                headers: pact_broker_response_headers
              )
          end
          it "returns nil" do
            response = pact_broker_client.pacticipants.versions.pacts.latest consumer: 'Condor', provider: 'Pricing Service'
            expect(response).to eq(nil)
          end
        end
      end
      describe "finding the latest production version" do
        context "when a pact is found" do
          before do
            pact_broker.
              given("a pact between Condor and the Pricing Service exists for the production version of Condor").
              upon_receiving("a request to retrieve the pact between the production verison of Condor and the Pricing Service").
              with(
                  method: :get,
                  path: '/pact/provider/Pricing%20Service/consumer/Condor/latest/prod',
                  headers: get_request_headers
              ).
              will_respond_with(
                status: 200,
                headers: {'Content-Type' => 'application/json', 'X-Pact-Consumer-Version' => consumer_version},
                body: pact_hash,
                headers: pact_broker_response_headers
              )
          end

          it "returns the pact json" do
            response = pact_broker_client.pacticipants.versions.pacts.latest consumer: 'Condor', provider: 'Pricing Service', tag: 'prod'
            expect(response).to eq(pact_json)
          end
        end
      end
    end

    describe "retriving versions" do
      context "when retrieving the production details of a version" do
        context "when a version is found" do
          let(:repository_ref) { "package/pricing-service-1.2.3"}
          let(:tags) { ['prod']}
          let(:body) { { number: '1.2.3', repository_ref: repository_ref, tags: tags } }
          before do
            pact_broker.
              given("a version with production details exists for the Pricing Service").
              upon_receiving("a request for the latest version tagged with 'prod'").
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
          it 'returns the version details' do
            expect( pact_broker_client.pacticipants.versions.latest pacticipant: 'Pricing Service', tag: 'prod' ).to eq body
          end
        end
      end
      context "when a version is not found" do
        before do
          pact_broker.
            given("no version exists for the Pricing Service").
            upon_receiving("a request for the latest version").
            with(
              method: :get,
              path: '/pacticipants/Pricing%20Service/versions/latest',
              headers: get_request_headers).
            will_respond_with(
              status: 404,
              headers: pact_broker_response_headers )
        end
        it 'returns nil' do
          expect( pact_broker_client.pacticipants.versions.latest pacticipant: 'Pricing Service' ).to eq nil
        end
      end
    end
  end
end
