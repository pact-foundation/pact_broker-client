require_relative 'pact_helper'
require 'pact_broker/client'

module PactBroker::Client
  describe PactBrokerClient, :pact => true do

    before do
      @backup_version = PactBroker::Client::VERSION
      silence_warnings do
        PactBroker::Client::VERSION = "2.0.0"
      end
    end

    after do
      silence_warnings do
        PactBroker::Client::VERSION = @backup_version
      end
    end

    let(:pact_hash) { {consumer: {name: 'Condor'}, provider: {name: 'Pricing Service'}, interactions: []} }
    let(:consumer_contract) { Pact::ConsumerContract.from_hash pact_hash }
    let(:pact_json) { pact_hash.to_json }
    let(:pact_broker_client) { PactBrokerClient.new(base_url: 'http://localhost:1234') }
    let(:consumer_version) { '1.3.0' }
    let(:version) { '1.3.0' }
    let(:pact_broker_version) { Pact::Term.new(:matcher => /\d+\.\d+\.\d+/, :generate => '1.0.0') }
    let(:pact_broker_response_headers) { {} }
    let(:default_request_headers) { { 'Content-Type' => 'application/json'} }
    let(:patch_request_headers)   { { 'Content-Type' => 'application/json'} }
    let(:get_request_headers)     { { 'Accept' => 'application/json'} }

    describe "publishing a pact" do

      let(:options) { { pact_json: pact_json, consumer_version: consumer_version }}

      context "when the provider already exists in the pact-broker" do
        before do
          pact_broker.
          given("the 'Pricing Service' already exists in the pact-broker").
          upon_receiving("a request to publish a pact").
          with({
              method: :put,
              path: '/pact/provider/Pricing%20Service/consumer/Condor/version/1.3.0',
              headers: default_request_headers,
              body: pact_hash }).
            will_respond_with( headers: pact_broker_response_headers,
              status: 201
            )
        end
        it "returns true" do
            expect(pact_broker_client.pacticipants.versions.pacts.publish(options)).to be_true
        end
      end

      context "when the provider, consumer, pact and version already exist in the pact-broker" do
        before do
          pact_broker.
          given("the 'Pricing Service' and 'Condor' already exist in the pact-broker, and Condor already has a pact published for version 1.3.0").
          upon_receiving("a request to publish a pact").
          with({
              method: :put,
              path: '/pact/provider/Pricing%20Service/consumer/Condor/version/1.3.0',
              headers: default_request_headers,
              body: pact_hash }).
            will_respond_with( headers: pact_broker_response_headers,
              status: 200
            )
        end
        it "returns true" do
            expect(pact_broker_client.pacticipants.versions.pacts.publish(options)).to be_true
        end
      end

      context "when the provider does not exist, but the consumer, pact and version already exist in the pact-broker" do
        before do
          pact_broker.
          given("'Condor' already exist in the pact-broker, but the 'Pricing Service' does not").
          upon_receiving("a request to publish a pact").
          with({
              method: :put,
              path: '/pact/provider/Pricing%20Service/consumer/Condor/version/1.3.0',
              headers: default_request_headers,
              body: pact_hash }).
            will_respond_with( headers: pact_broker_response_headers,
              status: 201
            )
        end
        it "returns true" do
            expect(pact_broker_client.pacticipants.versions.pacts.publish(options)).to be_true
        end
      end

      context "when publishing is not successful" do
        before do
          pact_broker.
          given("an error occurs while publishing a pact").
          upon_receiving("a request to publish a pact").
          with({
              method: :put,
              path: '/pact/provider/Pricing%20Service/consumer/Condor/version/1.3.0',
              headers: default_request_headers,
              body: pact_hash }).
            will_respond_with({
              status: 500,
              headers: {'Content-Type' => 'application/json'},
              body: {
                message: Pact::Term.new(matcher: /.*/, generate: 'An error occurred')
              }
            })
        end
        it "raises an error" do
          expect { pact_broker_client.pacticipants.versions.pacts.publish options }.to raise_error /An error occurred/
        end
      end

    end

    let(:repository_url ) { "git@git.realestate.com.au:business-systems/pricing-service" }

    describe "registering a repository url" do
      context "where the pacticipant does not already exist in the pact-broker" do
        before do
          pact_broker.
          given("the 'Pricing Service' does not exist in the pact-broker").
          upon_receiving("a request to register the repository URL of a pacticipant").
          with(
              method: :patch,
              path: '/pacticipants/Pricing%20Service',
              headers: patch_request_headers,
              body: {repository_url: repository_url} ).
            will_respond_with(
              status: 201,
              headers: pact_broker_response_headers
            )
        end
        it "returns true" do
          expect(pact_broker_client.pacticipants.update({:pacticipant => 'Pricing Service', :repository_url => repository_url})).to be_true
        end
      end
      context "where the 'Pricing Service' exists in the pact-broker" do
        before do
          pact_broker.
          given("the 'Pricing Service' already exists in the pact-broker").
          upon_receiving("a request to register the repository URL of a pacticipant").
          with(
              method: :patch,
              path: '/pacticipants/Pricing%20Service',
              headers: patch_request_headers,
              body: {repository_url: repository_url} ).
            will_respond_with(
              status: 200,
              headers: pact_broker_response_headers
            )
        end
        it "returns true" do
          expect(pact_broker_client.pacticipants.update({:pacticipant => 'Pricing Service', :repository_url => repository_url})).to be_true
        end
      end
    end

    describe "tagging a version with prod details" do
      let(:repository_ref) { "packages/condor-#{version}" }

      let(:tag_options) { {pacticipant: 'Condor', version: version, repository_ref: repository_ref, :tag => 'prod'} }
      context "when the component exists" do
        before do
          pact_broker.
          given("'Condor' exists in the pact-broker").
          upon_receiving("a request to tag the production version of Condor").
          with(
              method: :patch,
              path: '/pacticipants/Condor/versions/1.3.0',
              headers: patch_request_headers,
              body: {:tags => ['prod'], :repository_ref => repository_ref } ).
            will_respond_with(
              status: 200,
              headers: pact_broker_response_headers
            )
        end
        it "returns true" do
          expect(pact_broker_client.pacticipants.versions.update tag_options).to be_true
        end
      end
      context "when the component does not exist" do
        before do
          pact_broker.
          given("'Condor' does not exist in the pact-broker").
          upon_receiving("a request to tag the production version of Condor").
          with(
              method: :patch,
              path: '/pacticipants/Condor/versions/1.3.0',
              headers: patch_request_headers,
              body: {:tags => ['prod'], :repository_ref => repository_ref } ).
            will_respond_with(
              status: 201,
              headers: pact_broker_response_headers
            )
        end
        it "returns true" do
          expect(pact_broker_client.pacticipants.versions.update tag_options).to be_true
        end
      end
    end

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
            will_respond_with( headers: pact_broker_response_headers,
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
            with({
                method: :get,
                path: '/pact/provider/Pricing%20Service/consumer/Condor/latest',
                headers: {}
            }).
            will_respond_with({
              status: 200,
              headers: response_headers,
              body: pact_hash
            })
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
            with({
                method: :get,
                path: '/pact/provider/Pricing%20Service/consumer/Condor/latest',
                headers: {}
            }).
            will_respond_with({
              status: 404,
              headers: pact_broker_response_headers
            })
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
            with({
                method: :get,
                path: '/pact/provider/Pricing%20Service/consumer/Condor/latest/prod',
                headers: get_request_headers
            }).
            will_respond_with({
              status: 200,
              headers: {'Content-Type' => 'application/json', 'X-Pact-Consumer-Version' => consumer_version},
              body: pact_hash,
              headers: pact_broker_response_headers
            })
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
              will_respond_with( status: 200,
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
            with(method: :get, path: '/pacticipants/Pricing%20Service/versions/latest', headers: get_request_headers).
            will_respond_with( status: 404, headers: pact_broker_response_headers )
        end
        it 'returns nil' do
          expect( pact_broker_client.pacticipants.versions.latest pacticipant: 'Pricing Service' ).to eq nil
        end
      end
    end
  end
end
