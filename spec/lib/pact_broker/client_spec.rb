require 'spec_helper'

require 'pact_broker/client'

module PactBroker
  describe Client do

    describe 'initialize' do
      subject { Client.new }
      it 'sets the base_uri to http://pact-broker by default' do
        expect(subject.base_url).to eq('http://pact-broker')
      end

      it 'allows configuration of the base_uri' do
        expect(Client.new(base_url: 'https://blah').base_url).to eq('https://blah')
      end
    end
  end

end