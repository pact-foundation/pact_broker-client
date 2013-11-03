require 'spec_helper'
require_relative 'pact_helper'


module PactBroker::Client
  describe PactBrokerClient, :pact => true do

    let(:pact_broker_client) { PactBrokerClient.new(base_url: 'http://localhost:1234') }

    describe "listing pacticipants" do
      context "when a pacticipant exists" do
        let(:response_body) { JSON.parse(File.read("./spec/support/pacticipants_list.json"))}
        before do
          pact_broker.
          given("the 'Pricing Service' already exists in the pact-broker").
          upon_receiving("a request to list pacticipants").
          with(
              method: :get,
              path: '/pacticipants',
              headers: {} ).
            will_respond_with( headers: {'Content-Type' => 'application/json+hal'},
              status: 200,
              body: response_body
            )
        end
        it "returns the response body" do
            expect(pact_broker_client.pacticipants.list).to eq response_body
        end
      end
    end

    describe "get pacticipant" do
      context "when the pacticipant exists" do
        let(:response_body) { JSON.parse(File.read("./spec/support/pacticipant_get.json"))}
        let(:options) { {pacticipant: 'Pricing Service'}}
        before do
          pact_broker.
          given("the 'Pricing Service' already exists in the pact-broker").
          upon_receiving("a request to get the Pricing Service").
          with(
              method: :get,
              path: '/pacticipants/Pricing%20Service',
              headers: {} ).
            will_respond_with( headers: {'Content-Type' => 'application/json+hal'},
              status: 200,
              body: response_body
            )
        end
        it "returns the response body" do
            expect(pact_broker_client.pacticipants.get1(options)).to eq response_body
        end
      end
    end
  end
end