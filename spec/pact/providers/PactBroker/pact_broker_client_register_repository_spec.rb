require 'pact_broker/client/pact_broker_client'
require_relative '../../../pact_ruby_v2_spec_helper'

module PactBroker::Client
  describe Pacticipants, :pact => true do

  pact_broker
  include_context "pact broker"
  include_context "pact broker - pact-ruby-v2"

    let(:repository_url ) { "git@git.realestate.com.au:business-systems/pricing-service" }

    describe "registering a repository url" do
      context "where the pacticipant does not already exist in the pact-broker" do
        let(:interaction) do
          new_interaction.
            given("the 'Pricing Service' does not exist in the pact-broker").
            upon_receiving("a request to register the repository URL of a pacticipant").
            with_request(
                method: :patch,
                path: '/pacticipants/Pricing%20Service',
                headers: old_patch_request_headers,
                body: {repository_url: repository_url} ).
              will_respond_with(
                status: 201,
                headers: pact_broker_response_headers
              )
        end
        it "returns true" do
          interaction.execute do | mockserver |
            expect(pact_broker_client.pacticipants.update({:pacticipant => 'Pricing Service', :repository_url => repository_url})).to be true
          end
        end
      end
      context "where the 'Pricing Service' exists in the pact-broker" do
        let(:interaction) do
          new_interaction.
            given("the 'Pricing Service' already exists in the pact-broker").
            upon_receiving("a request to register the repository URL of a pacticipant").
            with_request(
              method: :patch,
              path: '/pacticipants/Pricing%20Service',
              headers: old_patch_request_headers,
              body: { repository_url: repository_url }).
            will_respond_with(
              status: 200,
              headers: pact_broker_response_headers
            )
        end
        it "returns true" do
          interaction.execute do | mockserver |
            expect(pact_broker_client.pacticipants.update({:pacticipant => 'Pricing Service', :repository_url => repository_url})).to be true
          end
        end
      end
    end
  end
end