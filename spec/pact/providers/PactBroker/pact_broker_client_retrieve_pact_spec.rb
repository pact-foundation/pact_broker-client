require_relative '../../../pact_ruby_v2_spec_helper'
require 'pact_broker/client'

module PactBroker::Client
  describe Pacts, :pact => true do

  pact_broker
  include_context "pact broker"
  include_context "pact broker - pact-ruby-v2"

    describe "retrieving a pact" do
      describe "retriving a specific version" do
        let(:interaction) do
          new_interaction.
            given("the 'Pricing Service' and 'Condor' already exist in the pact-broker, and Condor already has a pact published for version 1.3.0").
            upon_receiving("a request retrieve a pact for a specific version").
            with_request(
              method: :get,
              path: '/pacts/provider/Pricing%20Service/consumer/Condor/version/1.3.0',
              headers: {} ).
            will_respond_with(
              headers: pact_broker_response_headers,
              status: 200,
              body: pact_hash
            )
        end
        it "returns the pact json" do
          interaction.execute do | mockserver |
            response = pact_broker_client.pacticipants.versions.pacts.get consumer: 'Condor', provider: 'Pricing Service', consumer_version: '1.3.0'
            expect(response).to eq(pact_json)
          end
        end
      end

      describe "finding the latest version" do
        context "when a pact is found" do

          let(:response_headers) do
            pact_broker_response_headers.merge(
              {'Content-Type' => match_regex(%r{application/.*json.*},'application/hal+json')},
              'X-Pact-Consumer-Version' => consumer_version
            )
          end
          let(:interaction) do
            new_interaction.
              given("a pact between Condor and the Pricing Service exists").
              upon_receiving("a request to retrieve the latest pact between Condor and the Pricing Service").
              with_request(
                method: :get,
                path: '/pacts/provider/Pricing%20Service/consumer/Condor/latest',
                headers: {}
              ).
              will_respond_with(
                status: 200,
                headers: response_headers,
                body: pact_hash
              )
          end

          it "returns the pact json" do
            interaction.execute do | mockserver |
              response = pact_broker_client.pacticipants.versions.pacts.latest consumer: 'Condor', provider: 'Pricing Service'
              expect(response).to eq(pact_json)
            end
          end

        end
        context "when no pact is found" do
          let(:interaction) do
            new_interaction.
              given("no pact between Condor and the Pricing Service exists").
              upon_receiving("a request to retrieve the latest pact between Condor and the Pricing Service").
              with_request(
                method: :get,
                path: '/pacts/provider/Pricing%20Service/consumer/Condor/latest',
                headers: {}
              ).
              will_respond_with(
                status: 404
              )
          end
          it "returns nil" do
            interaction.execute do | mockserver |
              response = pact_broker_client.pacticipants.versions.pacts.latest consumer: 'Condor', provider: 'Pricing Service'
              expect(response).to eq(nil)
            end
          end
        end
      end
      describe "finding the latest production version" do
        context "when a pact is found" do
          let(:interaction) do
            new_interaction.
              given("a pact between Condor and the Pricing Service exists for the production version of Condor").
              upon_receiving("a request to retrieve the pact between the production verison of Condor and the Pricing Service").
              with_request(
                  method: :get,
                  path: '/pacts/provider/Pricing%20Service/consumer/Condor/latest/prod',
                  headers: { 'Accept' => 'application/hal+json, application/json'}
              ).
              will_respond_with(
                status: 200,
                body: pact_hash,
                headers: pact_broker_response_headers
              )
          end

          it "returns the pact json" do
            interaction.execute do | mockserver |
              response = pact_broker_client.pacticipants.versions.pacts.latest consumer: 'Condor', provider: 'Pricing Service', tag: 'prod'
              expect(response).to eq(pact_json)
            end
          end
        end
      end
    end

  end
end
