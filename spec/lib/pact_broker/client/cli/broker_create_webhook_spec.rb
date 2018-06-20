require 'pact_broker/client/cli/broker'
require 'pact_broker/client/webhooks/create'

module PactBroker
  module Client
    module CLI
      describe Broker do
        describe "create_webhook" do
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
              verbose: true
            }
          end

          let(:expected_params) do
            {
              http_method: "POST",
              url: "http://webhook",
              headers: { "Foo" => "bar", "Bar" => "foo"},
              username: "username",
              password: "password",
              body: "data",
              consumer: "consumer",
              provider: "provider",
              events: ["contract_content_changed"]
            }.tap { |it| Pact::Fixture.add_fixture(:create_webhook_params, it) }
          end

          subject {  broker.create_webhook "http://webhook" }

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
              expect(pact_broker_client_options).to eq(basic_auth: { username: "username", password: "password"}, verbose: true)
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
              expect { subject }.to raise_error PactBroker::Client::Error, /You must select at least one/
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
                expect(pact_broker_client_options).to eq(verbose: true)
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

              it "raises a PactBroker::Client::Error" do
                expect { subject }.to raise_error PactBroker::Client::Error, /Couldn't read data from file/
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
          end
        end
      end
    end
  end
end
