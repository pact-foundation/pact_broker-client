require 'pact_broker/client/pact_hash'
require 'pact_broker/client/hal/http_client'

shared_context "pact broker" do
  before do
    allow_any_instance_of(PactBroker::Client::Hal::HttpClient).to receive(:sleep)
    allow_any_instance_of(PactBroker::Client::Hal::HttpClient).to receive(:default_max_tries).and_return(1)
  end
  let(:pact_hash) { PactBroker::Client::PactHash[consumer: {name: 'Condor'}, provider: {name: 'Pricing Service'}, interactions: []] }
  let(:consumer_contract) { Pact::ConsumerContract.from_hash pact_hash }
  let(:pact_json) { pact_hash.to_json }
  let(:pact_broker_client) { PactBroker::Client::PactBrokerClient.new(client_config) }
  let(:broker_base_url) { 'http://localhost:1234' }
  let(:client_config) { { base_url: broker_base_url } }
  let(:consumer_version) { '1.3.0' }
  let(:version) { '1.3.0' }
  let(:pact_broker_version) { Pact::Term.new(:matcher => /\d+\.\d+\.\d+/, :generate => '1.0.0') }
  let(:pact_broker_response_headers) { {'Content-Type' => 'application/hal+json;charset=utf-8'} }
  let(:default_request_headers) { { 'Content-Type' => 'application/json'} }
  let(:old_patch_request_headers)   { { 'Content-Type' => 'application/json'} }
  let(:patch_request_headers)   { { 'Content-Type' => 'application/merge-patch+json'} }
  let(:put_request_headers)     { { 'Content-Type' => 'application/json', 'Accept' => 'application/hal+json'} }
  let(:post_request_headers)    { { 'Content-Type' => 'application/json', 'Accept' => 'application/hal+json'} }
  let(:get_request_headers)     { { 'Accept' => 'application/hal+json'} }
end
