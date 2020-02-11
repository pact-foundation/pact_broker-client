require 'pact_broker/client/cli/broker'
require 'pact_broker/client/webhooks/create'

module PactBroker
  module Client
    module CLI
      describe Broker do
        describe "create_webhook" do

          let(:broker) { Broker.new }

          subject { broker.create_webhook "http://webhook" }

          it "calls PactBroker::Client::Webhooks::Create with the webhook params" do
            expect(broker).to receive(:run_webhook_commands).with("http://webhook")

            subject
          end
        end
      end
    end
  end
end
