require 'pact_broker/client/cli/broker'
require 'pact_broker/client/cli/version_selector_options_parser'
require 'pact_broker/client/can_i_deploy'

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
        let(:version_selectors) { [{pacticipant: "Foo", version: "1"}] }
        let(:minimum_valid_options) do
          {
            broker_base_url: 'http://pact-broker',
            output: 'table',
            verbose: 'verbose',
            retry_while_unknown: 1,
            retry_interval: 2,
            limit: 1000,
            dry_run: false
          }
        end

        let(:invoke_can_i_deploy) { subject.can_i_deploy }

        it "parses the pacticipant names and versions" do
          expect(VersionSelectorOptionsParser).to receive(:call).with(ARGV)
          invoke_can_i_deploy
        end

        it "invokes the CanIDeploy service" do
          expect(CanIDeploy).to receive(:call).with(version_selectors, { to_tag: nil, to_environment: nil, limit: 1000, ignore_selectors: []}, {output: 'table', retry_while_unknown: 1, retry_interval: 2, dry_run: false, verbose: "verbose"}, { pact_broker_base_url: 'http://pact-broker', verbose: 'verbose' })
          invoke_can_i_deploy
        end

        context "with a missing --version and --latest" do
          let(:version_selectors) { [{pacticipant: "Foo", version: nil}] }

          it "raises an error" do
            expect { invoke_can_i_deploy }.to raise_error Thor::RequiredArgumentMissingError, /The version must be specified/
          end
        end

        context "with --to" do
          before do
            subject.options.to = 'prod'
          end

          it "passes the value as the matrix options" do
            expect(CanIDeploy).to receive(:call).with(anything, {to_tag: 'prod', to_environment: nil, limit: 1000, ignore_selectors: []}, anything, anything)
            invoke_can_i_deploy
          end
        end

        context "with --to-environment" do
          before do
            subject.options.to_environment = 'prod'
          end

          it "passes the value as the matrix options" do
            expect(CanIDeploy).to receive(:call).with(anything, {to_tag: nil, to_environment: 'prod', limit: 1000, ignore_selectors: []}, anything, anything)
            invoke_can_i_deploy
          end

          context "when the environment is an empty string" do
            before do
              subject.options.to_environment = ' '
            end

            it "raises an error" do
              expect { invoke_can_i_deploy }.to raise_error ::Thor::RequiredArgumentMissingError
            end
          end
        end

        context "with basic auth" do
          before do
            subject.options.broker_username = 'foo'
            subject.options.broker_password = 'bar'
          end

          it "invokes the CanIDeploy service with the basic auth credentials" do
            expect(CanIDeploy).to receive(:call).with(anything, anything, anything, { pact_broker_base_url: 'http://pact-broker', basic_auth: {username: "foo", password: "bar"}, verbose: 'verbose'})
            invoke_can_i_deploy
          end
        end

        context "with a bearer token" do
          before do
            subject.options.broker_token = "some token"
          end

          it "invokes the CanIDeploy service with the basic auth credentials" do
            expect(CanIDeploy).to receive(:call).with(anything, anything, anything, {pact_broker_base_url: 'http://pact-broker', token: "some token", verbose: 'verbose'})
            invoke_can_i_deploy
          end
        end

        context "when PACT_BROKER_CAN_I_DEPLOY_DRY_RUN=true" do
          before do
            allow(ENV).to receive(:[]).and_call_original
            allow(ENV).to receive(:[]).with("PACT_BROKER_CAN_I_DEPLOY_DRY_RUN").and_return("true")
          end

          it "invokes the CanIDeploy service with dry_run set to true" do
            expect(CanIDeploy).to receive(:call).with(anything, anything, hash_including(dry_run: true), anything)
            invoke_can_i_deploy
          end
        end

        context "when PACT_BROKER_CAN_I_DEPLOY_IGNORE=Some Service" do
          before do
            allow(ENV).to receive(:fetch).and_call_original
            allow(ENV).to receive(:fetch).with("PACT_BROKER_CAN_I_DEPLOY_IGNORE", "").and_return("Some Service, Some Other Service")
          end

          it "invokes the CanIDeploy service with ignore selectors" do
            expect(CanIDeploy).to receive(:call).with(anything, hash_including(ignore_selectors: [ { pacticipant: "Some Service" }, { pacticipant: "Some Other Service" } ]), anything, anything)
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
            exited_explicitly = false
            exited_explicitlyerror = nil
            begin
              invoke_can_i_deploy
            rescue SystemExit => e
              exited_explicitly = true
              error = e
            end
            expect(exited_explicitly).to be true
            expect(error.status).to be 1
          end

          context "when an exit status is specified" do
            before do
              allow(ENV).to receive(:fetch).and_call_original
              allow(ENV).to receive(:fetch).with('PACT_BROKER_CAN_I_DEPLOY_EXIT_CODE_BETA', '').and_return("0")
            end

            it "exits with the specified code" do
              exited_explicitly = false
              error = nil
              begin
                invoke_can_i_deploy
              rescue SystemExit => e
                exited_explicitly = true
                error = e
              end
              expect(exited_explicitly).to be true
              expect(error.status).to be 0
            end

            it "prints the configured exit code" do
              expect($stderr).to receive(:puts).with("Exiting can-i-deploy with configured exit code 0")
              expect($stdout).to receive(:puts).with(message)
              begin
                invoke_can_i_deploy
              rescue SystemExit
              end
            end
          end
        end
      end
    end
  end
end
