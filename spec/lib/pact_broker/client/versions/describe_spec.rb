require 'pact_broker/client/versions/describe'

module PactBroker
  module Client
    class Versions
      describe Describe do
        describe ".call" do

          let(:versions_client) do
            instance_double('PactBroker::Client::Versions', latest: version_hash)
          end

          let(:pact_broker_base_url) { 'http://broker' }
          let(:pact_broker_client_options) { {} }
          let(:pact_broker_client) { instance_double('PactBroker::Client::PactBrokerClient')}
          let(:version_hash) do
            {
              foo: 'bar'
            }
          end

          let(:params) do
            {
              pacticipant: 'foo',
              latest: true,
              tag: 'bar'
            }
          end

          let(:options) do
            {
              output: 'someformat'
            }
          end

          before do
            allow(PactBroker::Client::PactBrokerClient).to receive(:new).and_return(pact_broker_client)
            allow(pact_broker_client).to receive_message_chain(:pacticipants, :versions).and_return(versions_client)
            allow(Formatter).to receive(:call).and_return('formatted_output')
          end

          subject { Describe.call(params, options, pact_broker_base_url, pact_broker_client_options) }

          it "invokes the versions client" do
            expect(versions_client).to receive(:latest).with(params)
            subject
          end

          it "formats the output" do
            expect(Formatter).to receive(:call).with(version_hash, 'someformat')
            subject
          end

          it "returns a successful result" do
            expect(subject.success).to be true
          end

          it "returns a result with the formatted output as the message" do
            expect(subject.message).to eq 'formatted_output'
          end
        end
      end
    end
  end
end
