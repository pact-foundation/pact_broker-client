require 'pact_broker/client/user_agent'

module PactBroker
  module Client
    describe '.user_agent_string' do
      around do |example|
        original = PactBroker::Client.tool_identifier
        example.run
        PactBroker::Client.tool_identifier = original
      end

      context 'without tool_identifier' do
        before { PactBroker::Client.tool_identifier = nil }

        it 'returns the base user agent string' do
          expect(PactBroker::Client.user_agent_string('net-http', '1.2.3')).to eq(
            "pact_broker-client/#{VERSION} net-http/1.2.3 ruby/#{RUBY_VERSION}"
          )
        end
      end

      context 'with tool_identifier set' do
        before { PactBroker::Client.tool_identifier = 'pact-standalone/9.9.9' }

        it 'prepends the tool identifier' do
          expect(PactBroker::Client.user_agent_string('net-http', '1.2.3')).to eq(
            "pact-standalone/9.9.9 pact_broker-client/#{VERSION} net-http/1.2.3 ruby/#{RUBY_VERSION}"
          )
        end
      end

      context 'with tool_identifier set to empty string' do
        before { PactBroker::Client.tool_identifier = '' }

        it 'returns the base user agent string without prefix' do
          expect(PactBroker::Client.user_agent_string('net-http', '1.2.3')).to eq(
            "pact_broker-client/#{VERSION} net-http/1.2.3 ruby/#{RUBY_VERSION}"
          )
        end
      end

      context 'tool_identifier= and tool_identifier' do
        it 'can be set and retrieved' do
          PactBroker::Client.tool_identifier = 'my-tool/1.0'
          expect(PactBroker::Client.tool_identifier).to eq 'my-tool/1.0'
        end
      end
    end
  end
end
