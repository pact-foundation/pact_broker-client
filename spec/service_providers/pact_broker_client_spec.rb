require_relative 'pact_helper'
require 'pact_broker/client'

def silence_warnings
  old_verbose, $VERBOSE = $VERBOSE, nil
  yield
ensure
  $VERBOSE = old_verbose
end

describe PactBroker::ClientSupport, :pact => true do

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
  let(:pact_broker_client) { PactBroker::Client.new(base_url: 'http://localhost:1234') }
  let(:consumer_version) { '1.3.0' }
  let(:version) { '1.3.0' }
  let(:pact_broker_version) { Pact::Term.new(:matcher => /\d+\.\d+\.\d+/, :generate => '1.0.0') }
  let(:pact_broker_response_headers) { {} }
  let(:default_request_headers) { {'X-Pact-Broker-Client-Version' => '2.0.0', 'Content-Type' => 'application/json'} }
  let(:patch_request_headers)   { {'X-Pact-Broker-Client-Version' => '2.0.0', 'Content-Type' => 'application/json+patch'} }
  let(:get_request_headers)     { {'X-Pact-Broker-Client-Version' => '2.0.0', 'Accept' => 'application/json'} }

  describe "pacts.create" do

    let(:options) { { pact: pact_json, consumer_version: consumer_version }}

    context "when the provider already exists in the pact-broker" do
      before do
        pact_broker.
        given("the 'Pricing Service' already exists in the pact-broker").
        upon_receiving("a request to publish a pact").
        with({
            method: :put,
            path: '/pacticipant/Condor/versions/1.3.0/pacts/Pricing%20Service',
            headers: default_request_headers,
            body: pact_hash }).
          will_respond_with( headers: pact_broker_response_headers,
            status: 201
          )
      end
      it "returns true" do
          pact_broker_client.pacticipants.versions.pacts.publish options
      end
    end

    context "when the provider, consumer, pact and version already exist in the pact-broker" do
      before do
        pact_broker.
        given("the 'Pricing Service' and 'Condor' already exist in the pact-broker, and Condor already has a pact published for version 1.3.0").
        upon_receiving("a request to publish a pact").
        with({
            method: :put,
            path: '/pacticipant/Condor/versions/1.3.0/pacts/Pricing%20Service',
            headers: default_request_headers,
            body: pact_hash }).
          will_respond_with( headers: pact_broker_response_headers,
            status: 200
          )
      end
      it "returns true" do
          pact_broker_client.pacticipants.versions.pacts.publish options
      end
    end

    context "when publishing is not successful" do
      before do
        pact_broker.
        given("an error occurs while publishing a pact").
        upon_receiving("a request to publish a pact").
        with({
            method: :put,
            path: '/pacticipant/Condor/versions/1.3.0/pacts/Pricing%20Service',
            headers: default_request_headers,
            body: pact_hash }).
          will_respond_with({
            status: 500,
            headers: pact_broker_response_headers,
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

  let(:repository_url ) { "git@git.realestate.com.au:business-systems/condor.git" }

  describe "registering a repository url" do
    context "where the pacticipant does not already exist in the pact-broker" do
      before do
        pact_broker.
        given("the 'Pricing Service' does not exist in the pact-broker").
        upon_receiving("a request to register the repository URL of a pacticipant").
        with(
            method: :patch,
            path: '/pacticipant/Pricing%20Service',
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
            path: '/pacticipant/Pricing%20Service',
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

  describe "retrieving a repository url" do
    context "where the pacticipant does not already exist in the pact-broker" do
      before do
        pact_broker.
        given("the 'Pricing Service' does not exist in the pact-broker").
        upon_receiving("a request to retrieve the repository URL of the 'Pricing Service'").
        with(
            method: :get,
            path: '/pacticipant/Pricing%20Service/repository_url',
            headers: get_request_headers.merge({'Accept' => 'text/plain'})).
          will_respond_with(
            status: 404,
            headers: pact_broker_response_headers
          )
      end
      it "returns nil" do
        expect(pact_broker_client.pacticipants.repository_url({:pacticipant => 'Pricing Service'})).to eq(nil)
      end
    end
    context "where the 'Pricing Service' exists in the pact-broker" do
      before do
        pact_broker.
        given("the 'Pricing Service' already exists in the pact-broker").
        upon_receiving("a request to retrieve the repository URL of the 'Pricing Service'").
        with(
            method: :get,
            path: '/pacticipant/Pricing%20Service/repository_url',
            headers: get_request_headers.merge({'Accept' => 'text/plain'})).
          will_respond_with(
            status: 200,
            headers: pact_broker_response_headers.merge({'Content-Type' => 'text/plain;charset=utf-8'}),
            body: repository_url
          )
      end
      it "returns the URL" do
        expect(pact_broker_client.pacticipants.repository_url({:pacticipant => 'Pricing Service'})).to eq repository_url
      end
    end
  end

  describe "versions.update" do
    let(:repository_ref) { "packages/condor-#{version}" }

    let(:tag_options) { {pacticipant: 'Condor', version: version, repository_ref: repository_ref, repository_url: repository_url, :tag => 'prod'} }
    context "when the component exists" do
      before do
        pact_broker.
        given("'Condor' exists in the pact-broker").
        upon_receiving("a request to tag the production version of Condor").
        with(
            method: :patch,
            path: '/pacticipant/Condor/versions/1.3.0',
            headers: patch_request_headers,
            body: {:tags => ['prod'], :repository_ref => repository_ref, :repository_url => repository_url} ).
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
            path: '/pacticipant/Condor/versions/1.3.0',
            headers: patch_request_headers,
            body: {:tags => ['prod'], :repository_ref => repository_ref, :repository_url => repository_url} ).
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

  describe "find_pact" do
    describe "finding the latest version" do
      context "when a pact is found" do

        let(:response_headers) { pact_broker_response_headers.merge({'Content-Type' => 'application/json', 'X-Pact-Consumer-Version' => consumer_version}) }
        before do
          pact_broker.
          given("a pact between Condor and the Pricing Service exists").
          upon_receiving("a request to retrieve the latest pact between Condor and the Pricing Service").
          with({
              method: :get,
              path: '/pacticipant/Condor/versions/last/pacts/Pricing%20Service',
              headers: get_request_headers
          }).
          will_respond_with({
            status: 200,
            headers: response_headers,
            body: pact_hash
          })
        end

        it "returns the pact json" do
          response = pact_broker_client.pacticipants.versions.pacts.last consumer: 'Condor', provider: 'Pricing Service'
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
              path: '/pacticipant/Condor/versions/last/pacts/Pricing%20Service',
              headers: get_request_headers
          }).
          will_respond_with({
            status: 404,
            headers: pact_broker_response_headers
          })
        end
        it "returns nil" do
          response = pact_broker_client.pacticipants.versions.pacts.last consumer: 'Condor', provider: 'Pricing Service'
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
              path: '/pacticipant/Condor/versions/last/pacts/Pricing%20Service',
              query: 'tag=prod',
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
          response = pact_broker_client.pacticipants.versions.pacts.last consumer: 'Condor', provider: 'Pricing Service', tag: 'prod'
          expect(response).to eq(pact_json)
        end
      end
    end
  end

  describe "pacticipants.versions.pacts.last" do
    context "when retrieving the production details of a version" do
      context "when a version is found" do
        let(:repository_url) { "git@git.realestate.com.au:business-systems/pricing-service.git" }
        let(:repository_ref) { "package/pricing-service-1.2.3"}
        let(:tags) { ['prod']}
        let(:body) { { number: '1.2.3', repository_url: repository_url, repository_ref: repository_ref, tags: tags } }
        before do
          pact_broker.
            given("a version with production details exists for the Pricing Service").
            upon_receiving("a request for the latest version tagged with 'prod'").
            with(method: :get, path: '/pacticipant/Pricing%20Service/versions/last', query: 'tag=prod', headers: get_request_headers).
            will_respond_with( status: 200,
              headers: pact_broker_response_headers.merge({'Content-Type' => 'application/json'}),
              body: body )
        end
        it 'returns the version details' do
          expect( pact_broker_client.pacticipants.versions.last pacticipant: 'Pricing Service', tag: 'prod' ).to eq body
        end
      end
    end
    context "when a version is not found" do
      before do
        pact_broker.
          given("no version exists for the Pricing Service").
          upon_receiving("a request for the latest version").
          with(method: :get, path: '/pacticipant/Pricing%20Service/versions/last', headers: get_request_headers).
          will_respond_with( status: 404, headers: pact_broker_response_headers )
      end
      it 'returns nil' do
        expect( pact_broker_client.pacticipants.versions.last pacticipant: 'Pricing Service' ).to eq nil
      end
    end
  end
end
