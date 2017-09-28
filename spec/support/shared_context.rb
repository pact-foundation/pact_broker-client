require 'pact_broker/client/pact_hash'
shared_context "pact broker" do

  let(:pact_hash) { PactBroker::Client::PactHash[consumer: {name: 'Condor'}, provider: {name: 'Pricing Service'}, interactions: []] }
  let(:consumer_contract) { Pact::ConsumerContract.from_hash pact_hash }
  let(:pact_json) { pact_hash.to_json }
  let(:pact_broker_client) { PactBroker::Client::PactBrokerClient.new(client_config) }
  let(:client_config) { { base_url: 'http://localhost:1234' } }
  let(:consumer_version) { '1.3.0' }
  let(:version) { '1.3.0' }
  let(:pact_broker_version) { Pact::Term.new(:matcher => /\d+\.\d+\.\d+/, :generate => '1.0.0') }
  let(:pact_broker_response_headers) { {} }
  let(:default_request_headers) { { 'Content-Type' => 'application/json'} }
  let(:patch_request_headers)   { { 'Content-Type' => 'application/json'} }
  let(:get_request_headers)     { { 'Accept' => 'application/json'} }

end
