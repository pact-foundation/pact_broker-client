require_relative '../../../pact_ruby_v2_spec_helper'
require 'pact_broker/client/pact_broker_client'


module PactBroker::Client
  describe PactBrokerClient, :pact => true do

    pact_broker
    let(:pact_broker_client) { PactBrokerClient.new(base_url: 'http://localhost:9999') }

    describe "listing pacts" do
      context "when pacts exist" do
        let(:response_body) { JSON.parse(File.read("./spec/support/pacts_latest_list.json"))}
        let(:expected_pacts) do
          [{
            :consumer => {
              :name => 'Condor',
              :version => {
                :number => '1.3.0'
              }
            },
            :provider => {
                :name => 'Pricing Service'
              }
            }
          ]
        end
        let(:interaction) do
          new_interaction.
          given("a pact between Condor and the Pricing Service exists").
          upon_receiving("a request to list the latest pacts").
          with_request(
              method: :get,
              path: '/pacts/latest',
              headers: {} ).
            will_respond_with( headers: {'Content-Type' => match_regex(%r{application/hal\+json.*},'application/hal+json')},
              status: 200,
              body: response_body
            )
        end
        it "returns the response body" do
          interaction.execute do |mock_server|
            expect(pact_broker_client.pacts.list_latest).to eq(expected_pacts)
          end
        end
      end
    end

    describe "listing pacticipants" do
      context "when a pacticipant exists" do
        let(:response_body) { JSON.parse(File.read("./spec/support/pacticipants_list.json"))}
        let(:interaction) do
          new_interaction.
          given("'Condor' exists in the pact-broker").
          upon_receiving("a request to list pacticipants").
          with_request(
              method: :get,
              path: '/pacticipants',
              headers: {} ).
            will_respond_with( headers: {'Content-Type' => match_regex(%r{application/hal\+json.*},'application/hal+json')},
              status: 200,
              body: response_body
            )
        end
        it "returns the response body" do
          interaction.execute do |mock_server|
            puts "mock_server: #{mock_server.url}"
            expect(pact_broker_client.pacticipants.list).to eq response_body
          end
        end
      end
    end

    describe "get pacticipant" do
      context "when the pacticipant exists" do
        let(:response_body) { JSON.parse(File.read("./spec/support/pacticipant_get.json"))}
        let(:options) { {pacticipant: 'Pricing Service'}}
        let(:interaction) do
          new_interaction.
          given("the 'Pricing Service' already exists in the pact-broker").
          upon_receiving("a request to get the Pricing Service").
          with_request(
              method: :get,
              path: '/pacticipants/Pricing%20Service',
              headers: {} ).
            will_respond_with( headers: {'Content-Type' => match_regex(%r{application/hal\+json.*},'application/hal+json')},
              status: 200,
              body: response_body
            )
        end
        it "returns the response body" do
          interaction.execute do |mock_server|
            expect(pact_broker_client.pacticipants.get1(options)).to eq response_body
          end
        end
      end
      context "when the pacticipant does not exist" do
        let(:options) { {pacticipant: 'Pricing Service'}}
        let(:interaction) do
          new_interaction.
          given("the 'Pricing Service' does not exist in the pact-broker").
          upon_receiving("a request to get the Pricing Service").
          with_request(
              method: :get,
              path: '/pacticipants/Pricing%20Service',
              headers: {} ).
            will_respond_with( status: 404 )
        end
        it "returns nil" do
          interaction.execute do |mock_server|
            expect(pact_broker_client.pacticipants.get1(options)).to be_nil
          end
        end
      end
    end
  end
end
