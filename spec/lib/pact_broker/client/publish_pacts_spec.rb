require 'spec_helper'
require 'fakefs/safe'
require 'pact_broker/client/publish_pacts'
require 'json'

module PactBroker
  module ClientSupport
    describe PublishPacts do

      before do
        FakeFS.activate!
        pacts_client.stub(:publish)
        PactBroker::Client.stub(:new).with(base_url: pact_broker_base_url).and_return(pact_broker_client)
      end

      after do
        FakeFS.deactivate!
      end

      let(:pact_broker_client) { double("PactBroker::Client")}
      let(:pact_files) { ['spec/pacts/consumer-provider.json']}
      let(:consumer_version) { "1.2.3" }
      let(:pact_hash) { {consumer: {name: 'Consumer'}, provider: {name: 'Provider'} } }
      let(:pacts_client) { instance_double("PactBroker::ClientSupport::Pacts")}
      let(:pact_broker_base_url) { 'http://some-host'}

      subject { PublishPacts.new(pact_broker_base_url, pact_files, consumer_version) }

      before do
        FileUtils.mkdir_p "spec/pacts"
        File.open("spec/pacts/consumer-provider.json", "w") { |file| file << pact_hash.to_json }
        pact_broker_client.stub_chain(:pacticipants, :versions, :pacts).and_return(pacts_client)
      end

      describe "call" do

        it "uses the pact_broker client to publish the given pact" do
          pacts_client.should_receive(:publish).with(pact_json: pact_hash.to_json, consumer_version: consumer_version)
          subject.call
        end

        context "when publishing is successful" do
          it "returns true" do
            expect(subject.call).to be_true
          end
        end

        context "when publishing one or more pacts fails" do
          let(:pact_files) { ['spec/pacts/doesnotexist.json','spec/pacts/consumer-provider.json']}
          before do
            $stderr.stub(:puts)
          end

          it "logs an message to stderr" do
            $stderr.should_receive(:puts).with(/Failed to publish pact/)
            subject.call
          end

          it "continues publishing the rest" do
            pacts_client.should_receive(:publish).with(pact_json: pact_hash.to_json, consumer_version: consumer_version)
            subject.call
          end

          it "returns false" do
            expect(subject.call).to be_false
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
      end
    end
  end
end