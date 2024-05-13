require 'pact_broker/client/cli/broker'
require 'pact_broker/client/webhooks/create'
require 'ostruct'

module PactBroker
  module Client
    module CLI
      describe Broker do
        describe "run_webhook_commands" do
          before do
            allow($stdout).to receive(:puts)
            allow(PactBroker::Client::Webhooks::Create).to receive(:call).and_return(command_result)
            broker.options = OpenStruct.new(options_hash)
          end

          let(:broker) { Broker.new }
          let(:data) { 'data' }
          let(:user) { "username:password" }
          let(:command_result) { double('command result', success: success, message: 'message') }
          let(:success) { true }
          let(:header) { ["Foo: bar", "Bar: foo"] }

          let(:options_hash) do
            {
              uuid: '9999',
              description: "some webhook",
              request: "POST",
              header: header,
              data: data,
              user: user,
              consumer: "consumer",
              provider: "provider",
              broker_base_url: "http://broker",
              broker_username: "username",
              broker_password: "password",
              contract_content_changed: true,
              verbose: true,
              team_uuid: "1234"
            }
          end

          let(:expected_params) do
            {
              uuid: '9999',
              description: "some webhook",
              http_method: "POST",
              url: "http://webhook",
              headers: { "Foo" => "bar", "Bar" => "foo"},
              username: "username",
              password: "password",
              body: "data",
              consumer: "consumer",
              consumer_label: nil,
              provider: "provider",
              provider_label: nil,
              events: ["contract_content_changed"],
              team_uuid: "1234"
            }.tap { |it| Pact::Fixture.add_fixture(:create_webhook_params, it) }
          end

          subject { broker.run_webhook_commands "http://webhook" }

          it "calls PactBroker::Client::Webhooks::Create with the webhook params" do
            expect(PactBroker::Client::Webhooks::Create).to receive(:call) do | params, _, _ |
              expect(params).to eq expected_params
              command_result
            end
            subject
          end

          it "calls PactBroker::Client::Webhooks::Create with pact broker details" do
            expect(PactBroker::Client::Webhooks::Create).to receive(:call) do | _, broker_base_url, pact_broker_client_options |
              expect(broker_base_url).to eq "http://broker"
              expect(pact_broker_client_options).to eq(pact_broker_base_url: 'http://broker', basic_auth: { username: "username", password: "password"}, verbose: true)
              command_result
            end
            subject
          end

          context "when neither event type is selected" do
            before do
              options_hash.delete(:contract_content_changed)
              broker.options = OpenStruct.new(options_hash)
            end

            it "raises an error" do
              expect { subject }.to raise_error WebhookCreationError, /You must specify at least one/
            end
          end

          context "with no basic auth" do
            before do
              options_hash.delete(:broker_username)
              options_hash.delete(:broker_password)
              broker.options = OpenStruct.new(options_hash)
            end

            it "calls Webhooks::Create without basic auth" do
              expect(PactBroker::Client::Webhooks::Create).to receive(:call) do | _, _, pact_broker_client_options |
                expect(pact_broker_client_options).to eq(verbose: true, pact_broker_base_url: 'http://broker')
                command_result
              end
              subject
            end
          end

          context "with a bearer token" do
            before do
              options_hash.delete(:broker_username)
              options_hash.delete(:broker_password)
              options_hash[:broker_token] = "token"
              broker.options = OpenStruct.new(options_hash)
            end

            it "calls Webhooks::Create without basic auth" do

              expect(PactBroker::Client::Webhooks::Create).to receive(:call) do | _, _, pact_broker_client_options |
                expect(pact_broker_client_options).to eq(verbose: true, token: "token", pact_broker_base_url: 'http://broker')
                command_result
              end
              subject
            end
          end

          context "when there are no headers specified" do
            let(:header) { nil }

            it "calls Webhooks::Create with an empty hash of headers" do
              expect(PactBroker::Client::Webhooks::Create).to receive(:call) do | params, _, _ |
                expect(params[:headers]).to eq({})
                command_result
              end
              subject
            end
          end

          context "when data is nil" do
            let(:data) { nil }

            it "alls Webhooks::Create with a nil body" do
              expect(PactBroker::Client::Webhooks::Create).to receive(:call) do | params, _, _ |
                expect(params[:body]).to be nil
                command_result
              end
              subject
            end
          end

          context "when a uuid is provided" do
            before do
              options_hash.merge!(uuid: '9999')
              expected_params.merge!(uuid: '9999')

              broker.options = OpenStruct.new(options_hash)
            end

            it "calls PactBroker::Client::Webhooks::Create with uuid in params" do
              expect(PactBroker::Client::Webhooks::Create).to receive(:call) do | params, _, _ |
                expect(params).to eq expected_params
                command_result
              end
              subject
            end
          end

          context "when a file reference is passed for the data" do
            before do
              FileUtils.mkdir_p "tmp"
              File.open("tmp/body.json", "w") { |file| file << "file" }
            end

            let(:data) { "@tmp/body.json" }

            it "reads the file and passes it in to the Webhooks::Create call" do
              expect(PactBroker::Client::Webhooks::Create).to receive(:call) do | params, _, _ |
                expect(params[:body]).to eq "file"
                command_result
              end
              subject
            end

            context "when the file is not found" do

              let(:data) { "@doesnotexist.json" }

              it "raises a WebhookCreationError" do
                expect { subject }.to raise_error WebhookCreationError, /Couldn't read data from file/
              end
            end

            context "when successful" do
              it "prints the message to stdout" do
                expect($stdout).to receive(:puts).with('message')
                subject
              end
            end

            context "when not successful" do
              let(:success) { false }

              it "prints the message to stderr" do
                expect($stdout).to receive(:puts).with('message')
                begin
                  subject
                rescue SystemExit
                end
              end

              it "exits with code 1" do
                exited_with_error = false
                begin
                  subject
                rescue SystemExit
                  exited_with_error = true
                end
                expect(exited_with_error).to be true
              end
            end

            context "when a PactBroker::Client::Error is raised" do
              before do
                allow(PactBroker::Client::Webhooks::Create).to receive(:call).and_raise(PactBroker::Client::Error, "foo")
              end

              it "raises a WebhookCreationError which does not show an ugly stack trace" do
                expect { subject }.to raise_error(WebhookCreationError, /foo/)
              end
            end

          end

          context "when both consumer name and label options are specified" do
            before do
              options_hash[:consumer_label] = "consumer_label"
              broker.options = OpenStruct.new(options_hash)
            end

            it "raises a WebhookCreationError" do
              expect { subject }.to raise_error(
                WebhookCreationError,
                "Consumer name (--consumer) and label (--consumer_label) options are mutually exclusive"
              )
            end
          end

          context "when both provider name and label options are specified" do
            before do
              options_hash[:provider_label] = "provider_label"
              broker.options = OpenStruct.new(options_hash)
            end

            it "raises a WebhookCreationError" do
              expect { subject }.to raise_error(
                WebhookCreationError,
                "Provider name (--provider) and label (--provider_label) options are mutually exclusive"
              )
            end
          end

          context "when participant labels are specified" do
            before do
              options_hash.delete(:consumer)
              options_hash.delete(:provider)
              options_hash.merge!(consumer_label: 'consumer_label', provider_label: 'provider_label')
              expected_params.merge!(
                consumer: nil,
                consumer_label: 'consumer_label',
                provider: nil,
                provider_label: 'provider_label'
              )

              broker.options = OpenStruct.new(options_hash)
            end

            it "calls PactBroker::Client::Webhooks::Create with participant labels in params" do
              expect(PactBroker::Client::Webhooks::Create).to receive(:call) do | params, _, _ |
                expect(params).to eq expected_params
                command_result
              end
              subject
            end
          end
        end
      end
    end
  end
end
