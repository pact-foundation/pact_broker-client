require 'spec_helper'
require 'fakefs/safe'
require 'pact_broker/client/publish_pacts'
require 'json'

module PactBroker
  module Client
    describe PublishPacts do

      before do
        FakeFS.activate!
        allow(pacts_client).to receive(:publish).and_return(latest_pact_url)
        allow(PactBroker::Client::PactBrokerClient).to receive(:new).with(base_url: pact_broker_base_url, client_options: pact_broker_client_options).and_return(pact_broker_client)
        allow($stdout).to receive(:puts)
      end

      after do
        FakeFS.deactivate!
      end

      let(:latest_pact_url) { 'http://example.org/latest/pact' }
      let(:pact_broker_client) { double("PactBroker::Client")}
      let(:pact_files) { ['spec/pacts/consumer-provider.json']}
      let(:consumer_version) { "1.2.3" }
      let(:pact_hash) { {consumer: {name: 'Consumer'}, provider: {name: 'Provider'}, interactions: [] } }
      let(:pacts_client) { instance_double("PactBroker::ClientSupport::Pacts")}
      let(:pact_broker_base_url) { 'http://some-host'}
      let(:pact_broker_client_options) do
        {
          basic_auth: {
            username: 'user',
            password: 'pass'
          }
        }
      end

      subject { PublishPacts.new(pact_broker_base_url, pact_files, consumer_version, pact_broker_client_options) }

      before do
        FileUtils.mkdir_p "spec/pacts"
        File.open("spec/pacts/consumer-provider.json", "w") { |file| file << pact_hash.to_json }
        allow(pact_broker_client).to receive_message_chain(:pacticipants, :versions, :pacts).and_return(pacts_client)
        allow(pacts_client).to receive(:version_published?).and_return(false)
      end

      describe "call" do

        it "uses the pact_broker client to publish the given pact" do
          expect(pacts_client).to receive(:publish).with(pact_json: pact_hash.to_json, consumer_version: consumer_version)
          subject.call
        end

        context "when publishing is successful" do

          it "puts the location of the latest pact" do
            allow($stdout).to receive(:puts)
            expect($stdout).to receive(:puts).with(/#{latest_pact_url}/)
            subject.call
          end
          it "returns true" do
            expect(subject.call).to be true
          end
        end

        context "when publishing one or more pacts fails" do
          let(:pact_files) { ['spec/pacts/doesnotexist.json','spec/pacts/consumer-provider.json']}

          before do
            allow($stderr).to receive(:puts)
          end

          it "logs an message to stderr" do
            expect($stderr).to receive(:puts).with(/Failed to publish pact/)
            subject.call
          end

          it "continues publishing the rest" do
            expect(pacts_client).to receive(:publish).with(pact_json: pact_hash.to_json, consumer_version: consumer_version)
            subject.call
          end

          it "returns false" do
            expect(subject.call).to be false
          end
        end

        context "when no pact files are specified" do
          let(:pact_files) { [] }
          it "raises a validation error" do
            expect { subject.call }.to raise_error(/No pact files found/)
          end
        end

        context "when consumer_version is blank" do
          let(:consumer_version) { " " }
          it "raises a validation error" do
            expect { subject.call }.to raise_error(/Please specify the consumer_version/)
          end
        end

        context "when pact_broker_base_url is blank" do
          let(:pact_broker_base_url) { " " }
          it "raises a validation errror" do
            expect { subject.call }.to raise_error(/Please specify the pact_broker_base_url/)
          end
        end

        context "when an error occurs every time while publishing a pact" do

          before do
            allow(Retry).to receive(:sleep)
            allow(pacts_client).to receive(:publish).and_raise("an error")
            allow($stderr).to receive(:puts)
          end

          it "retries multiple times" do
            expect(pacts_client).to receive(:publish).exactly(3).times
            subject.call
          end

          it "returns false" do
            expect(subject.call).to eq false
          end
        end

        context "when an error occurs less than the maximum number of retries" do

          before do
            allow(Retry).to receive(:sleep)
            tries = 0
            allow(pacts_client).to receive(:publish) do
              if tries == 0
                tries += 1
                raise "an error"
              else
                latest_pact_url
              end
            end
            allow($stderr).to receive(:puts)
          end

          it "retries multiple times" do
            expect(pacts_client).to receive(:publish).exactly(2).times
            subject.call
          end

          it "returns true" do
            expect(subject.call).to eq true
          end
        end
      end
    end
  end
end
