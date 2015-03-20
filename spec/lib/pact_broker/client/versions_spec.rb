require 'pact_broker/client/versions'
module PactBroker
  module Client
    describe Versions do
      let(:client_options) do
        { some_option: 'option value'}
      end
      let(:base_url) { 'https://blah' }

      describe 'pacts' do
        it 'initializes versions with base url and client options' do
          expect(PactBroker::Client::Pacts).to receive(:new).with(base_url: base_url, client_options: client_options)
          Versions.new(base_url: base_url, client_options: client_options).pacts
        end
      end
    end
  end
end