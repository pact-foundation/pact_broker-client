require 'pact_broker/client/cli/broker'

module PactBroker
  module Client
    module CLI
      describe Broker do
        before do
          subject.options = OpenStruct.new(minimum_valid_options)
          allow(VersionSelectorOptionsParser).to receive(:call).and_return(version_selectors)
          allow(CanIDeploy).to receive(:call).and_return(result)
          allow($stdout).to receive(:puts)
          allow($stderr).to receive(:puts)
        end

        let(:result) { instance_double('PactBroker::Client::CanIDeploy::Result', success: success, message: message) }
        let(:success) { true }
        let(:message) { 'message' }
        let(:version_selectors) { ['selector1'] }
        let(:minimum_valid_options) do
          {
            broker_base_url: 'http://pact-broker',
            output: 'table',
            verbose: 'verbose'
          }
        end

        let(:invoke_can_i_deploy) { subject.can_i_deploy }

        it "parses the pacticipant names and versions" do
          expect(VersionSelectorOptionsParser).to receive(:call).with(ARGV)
          invoke_can_i_deploy
        end

        it "invokes the CanIDeploy service" do
          expect(CanIDeploy).to receive(:call).with('http://pact-broker', version_selectors, {output: 'table'}, {verbose: 'verbose'})
          invoke_can_i_deploy
        end

        context "with basic auth" do
          before do
            subject.options = OpenStruct.new(minimum_valid_options.merge(broker_username: 'foo', broker_password: 'bar'))
          end

          it "invokes the CanIDeploy service with the basic auth credentials" do
            expect(CanIDeploy).to receive(:call).with(anything, anything, anything, {basic_auth: {username: "foo", password: "bar"}, verbose: 'verbose'})
            invoke_can_i_deploy
          end
        end

        context "when successful" do
          it "prints the message to stdout" do
            expect($stdout).to receive(:puts).with(message)
            invoke_can_i_deploy
          end
        end

        context "when not successful" do
          let(:success) { false }

          it "prints the message to stderr" do
            expect($stdout).to receive(:puts).with(message)
            begin
              invoke_can_i_deploy
            rescue SystemExit
            end
          end

          it "exits with code 1" do
            exited_with_error = false
            begin
              invoke_can_i_deploy
            rescue SystemExit
              exited_with_error = true
            end
            expect(exited_with_error).to be true
          end
        end
      end
    end
  end
end
