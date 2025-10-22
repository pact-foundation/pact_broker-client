require 'pact_broker/client/pact_broker_client'
require_relative '../../../pact_ruby_v2_spec_helper'


module PactBroker::Client
  describe PactBrokerClient, :pact => true do

  pact_broker
  include_context "pact broker"
  include_context "pact broker - pact-ruby-v2"

    # This endpoint fails on the pact_broker
    # it is the old end point only used with
    # PACT_BROKER_FEATURES=publish_pacts_using_old_api=true
    describe "publishing a pact", :skip do

      let(:options) { { pact_hash: pact_hash, consumer_version: consumer_version }}
      let(:location) { 'http://example.org/pacts/provider/Pricing%20Service/consumer/Condor/latest' }
      context "when the provider already exists in the pact-broker" do

        let(:interaction) do
          new_interaction.
          given("the 'Pricing Service' already exists in the pact-broker").
          upon_receiving("a request to publish a pact").
          with_request(
            method: :put,
            path: '/pacts/provider/Pricing%20Service/consumer/Condor/version/1.3.0',
            headers: default_request_headers,
            body: pact_hash ).
          will_respond_with(
            headers: pact_broker_response_headers,
            status: 201,
            body: {
              _links: {
                :'pb:latest-pact-version' => {
                  href: location
                }
              }
            }
          )
        end
        it "returns the URL to find the newly published pact" do
          interaction.execute do | mockserver |
            expect(pact_broker_client.pacticipants.versions.pacts.publish(options)).to eq location
          end
        end
      end

      context "when the provider, consumer, pact and version already exist in the pact-broker" do
        shared_examples "an already-existing pact" do |method|
          let(:interaction) do
            new_interaction.
              given("the 'Pricing Service' and 'Condor' already exist in the pact-broker, and Condor already has a pact published for version 1.3.0").
              upon_receiving("a request to publish a pact with method #{method}").
              with_request(
                method: method,
                path: '/pacts/provider/Pricing%20Service/consumer/Condor/version/1.3.0',
                headers: default_request_headers,
                body: pact_hash ).
              will_respond_with(
                headers: pact_broker_response_headers,
                status: 200,
                body: {
                  _links: {
                    :'pb:latest-pact-version' => {
                      href: location
                    }
                  }
                }
              )
          end

          it "returns true" do
            interaction.execute do | mockserver |
              expect(pact_broker_client.pacticipants.versions.pacts.publish(options)).to be_truthy
            end
          end
        end

        context "when the write method is set to merge" do
          let(:client_config) { super().merge(client_options: {write: :merge}) }

          it_behaves_like "an already-existing pact", :patch
        end

        context "when the write method is not set" do
          it_behaves_like "an already-existing pact", :put
        end
      end

      context "when the provider does not exist, but the consumer, pact and version already exist in the pact-broker" do
        let(:interaction) do
          new_interaction.
            given("'Condor' already exist in the pact-broker, but the 'Pricing Service' does not").
            upon_receiving("a request to publish a pact").
            with_request(
              method: :put,
              path: '/pacts/provider/Pricing%20Service/consumer/Condor/version/1.3.0',
              headers: default_request_headers,
              body: pact_hash ).
            will_respond_with(
              headers: pact_broker_response_headers,
              status: 201,
              body: {
                _links: {
                  :'pb:latest-pact-version' => {
                    href: location
                  }
                }
              }
            )
        end
        it "returns true" do
          interaction.execute do | mockserver |
            expect(pact_broker_client.pacticipants.versions.pacts.publish(options)).to be_truthy
          end
        end
      end

      context "when publishing is not successful" do
        let(:interaction) do
          new_interaction.
            given("an error occurs while publishing a pact").
            upon_receiving("a request to publish a pact").
            with_request(
              method: :put,
              path: '/pacts/provider/Pricing%20Service/consumer/Condor/version/1.3.0',
              headers: default_request_headers,
              body: pact_hash ).
            will_respond_with(
              status: 500,
              headers: {'Content-Type' => match_regex(%r{application/.*json.*},'application/hal+json')},
              body: {
                error: {
                  message: match_regex(/.*/,'An error occurred')
                }
              }
            )
        end
        it "raises an error" do
          interaction.execute do | mockserver |
            expect { pact_broker_client.pacticipants.versions.pacts.publish options }.to raise_error /An error occurred/
          end
        end
      end

    end
  end
end
