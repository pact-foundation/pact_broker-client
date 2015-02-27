require 'pact_broker/client/pacticipants'
module PactBroker
  module Client
    describe Pacticipants do
      let(:client_options) do
        { some_option: 'option value'}
      end
      let(:base_url) { 'https://blah' }

      describe 'versions' do
        it 'initializes versions with base url and client options' do
          expect(PactBroker::Client::Versions).to receive(:new).with(base_url: base_url, client_options: client_options)
          Pacticipants.new(base_url: base_url, client_options: client_options).versions
        end
      end
    end
  end
end