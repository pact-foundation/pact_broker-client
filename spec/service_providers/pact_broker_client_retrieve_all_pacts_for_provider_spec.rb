require_relative 'pact_helper'
require 'pact_broker/client'

module PactBroker::Client
  describe Pacts, :pact => true do

    include_context "pact broker"

    describe "retriving all pacts for provider" do
      let(:response_body) { JSON.parse(File.read("./spec/support/latest_pacts_for_provider.json")) }
      let(:expectedPactsArray) { [{:name => "Condor", :href => "http://example.org/pacts/provider/Pricing%20Service/consumer/Condor/version/1.3.0"}] }

      context "when retrieving all the latest pacts for provider with prod tag specified" do
        before do
          pact_broker.
              given("tagged as prod pact between Condor and the Pricing Service exists").
              upon_receiving("a request for the list of the latest prod pacts from all consumers for the Pricing Service'").
              with(
                  method: :get,
                  path: "/pacts/provider/Pricing%20Service/latest/prod",
                  headers: {}).
              will_respond_with(
                  status: 200,
                  body: response_body)
        end
        it 'returns the map of all provider latest prod pacts' do
          pactsArray = pact_broker_client.pacticipants.versions.pacts.list_latest_for_provider provider: 'Pricing Service', tag: 'prod'
          expect(pactsArray.length).to eq(1)
          expect(pactsArray).to eq(expectedPactsArray)
        end
      end
      context "when retrieving all the latest pacts for provider with no tag specified" do
        before do
          pact_broker.
              given("a latest pact between Condor and the Pricing Service exists").
              upon_receiving("a request for the list of the latest pacts from all consumers for the Pricing Service'").
              with(
                  method: :get,
                  path: "/pacts/provider/Pricing%20Service/latest",
                  headers: {}).
              will_respond_with(
                  status: 200,
                  body: response_body)
        end
        it 'returns the map of all provider latest pacts' do
          pactsArray = pact_broker_client.pacticipants.versions.pacts.list_latest_for_provider provider: 'Pricing Service'
          expect(pactsArray.length).to eq(1)
          expect(pactsArray).to eq(expectedPactsArray)
        end
      end
    end
  end
end
