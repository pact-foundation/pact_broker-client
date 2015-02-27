require 'spec_helper'

require 'pact_broker/client'

module PactBroker::Client
  describe PactBrokerClient do

    let(:client_options) do
      { some_option: 'option value'}
    end
    let(:base_url) { 'https://blah' }

    describe 'initialize' do
      subject { PactBrokerClient.new }
      it 'sets the base_uri to http://pact-broker by default' do
        expect(subject.base_url).to eq('http://pact-broker')
      end

      it 'sets the client options to empty hash by default' do
        expect(subject.client_options).to eq({})
      end

      it 'allows configuration of the base_uri' do
        expect(PactBrokerClient.new(base_url: base_url).base_url).to eq(base_url)
      end

      it 'allows configuration of the client options' do
        expect(PactBrokerClient.new(client_options: client_options).client_options).to eq(client_options)
      end
    end

    describe 'pacticipants' do
      it 'initializes pacticipants with base url and client options' do
        expect(PactBroker::Client::Pacticipants).to receive(:new).with(base_url: base_url, client_options: client_options)
        PactBrokerClient.new(base_url: base_url, client_options: client_options).pacticipants
      end
    end

    describe 'pacts' do
      it 'initializes [act] with base url and client options' do
        expect(PactBroker::Client::Pacts).to receive(:new).with(base_url: base_url, client_options: client_options)
        PactBrokerClient.new(base_url: base_url, client_options: client_options).pacts
      end
    end
  end

end