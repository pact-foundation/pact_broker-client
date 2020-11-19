require 'spec_helper'
require 'fakefs/safe'
require 'pact_broker/client/publish_pacts'
require 'json'

module PactBroker
  module Client
    describe PublishPacts do

      # The amount of stubbing that we have to do here indicates this class is doing
      # TOO MUCH and needs to be split up!
      before do
        FakeFS.activate!
        allow(pacts_client).to receive(:publish).and_return(latest_pact_url)
        allow(PactBroker::Client::PactBrokerClient).to receive(:new).and_return(pact_broker_client)
        allow(pact_broker_client).to receive_message_chain(:pacticipants, :versions).and_return(pact_versions_client)
        allow(pact_broker_client).to receive_message_chain(:pacticipants, :versions, :pacts).and_return(pacts_client)
        allow(pacts_client).to receive(:version_published?).and_return(false)
        allow($stdout).to receive(:puts)
        allow(Retry).to receive(:sleep)
        allow(MergePacts).to receive(:call) { | pact_hashes | pact_hashes[0] }
        FileUtils.mkdir_p "spec/pacts"
        File.open("spec/pacts/consumer-provider.json", "w") { |file| file << pact_hash.to_json }
        File.open("spec/pacts/consumer-provider-2.json", "w") { |file| file << pact_hash.to_json }
        File.open("spec/pacts/foo-bar.json", "w") { |file| file << pact_hash_2.to_json }
      end

      after do
        FakeFS.deactivate!
      end

      let(:latest_pact_url) { 'http://example.org/latest/pact' }
      let(:pact_broker_client) { double("PactBroker::Client")}
      let(:pact_file_paths) { ['spec/pacts/consumer-provider.json']}
      let(:consumer_version) { "1.2.3" }
      let(:tags) { nil }
      let(:pact_hash) { {consumer: {name: 'Consumer'}, provider: {name: 'Provider'}, interactions: [] } }
      let(:pact_hash_2) { {consumer: {name: 'Foo'}, provider: {name: 'Bar'}, interactions: [] } }
      let(:pacts_client) { instance_double("PactBroker::ClientSupport::Pacts")}
      let(:pact_versions_client) { instance_double("PactBroker::Client::Versions", tag: false) }
      let(:pact_broker_base_url) { 'http://some-host'}
      let(:pact_broker_client_options) do
        {
          basic_auth: {
            username: 'user',
            password: 'pass'
          }
        }
      end

      subject { PublishPacts.new(pact_broker_base_url, pact_file_paths, consumer_version, tags, pact_broker_client_options) }

      describe "call" do
        it "creates a PactBroker Client" do
          expect(PactBroker::Client::PactBrokerClient).to receive(:new).with(base_url: pact_broker_base_url, client_options: pact_broker_client_options)
          subject.call
        end

        it "uses the pact_broker client to publish the given pact" do
          expect(pacts_client).to receive(:publish).with(pact_hash: pact_hash, consumer_version: consumer_version)
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

        context "when publishing multiple files with the same consumer/provider" do
          let(:pact_file_paths) { ['spec/pacts/consumer-provider.json','spec/pacts/consumer-provider-2.json']}
          it "merges the files" do
            expect(MergePacts).to receive(:call).with([pact_hash, pact_hash])
            subject.call
          end
        end

        context "when publishing multiple files with different consumers" do
          let(:pact_file_paths) { ['spec/pacts/consumer-provider.json','spec/pacts/foo-bar.json']}
          let(:tags) { ['dev'] }

          it "tags each consumer" do
            expect(pact_versions_client).to receive(:tag).with(
              pacticipant: "Consumer",
              version: consumer_version,
              tag: "dev"
            )
            expect(pact_versions_client).to receive(:tag).with(
              pacticipant: "Foo",
              version: consumer_version,
              tag: "dev"
            )
            subject.call
          end
        end

        context "when publishing one or more pacts fails" do
          let(:pact_file_paths) { ['spec/pacts/consumer-provider.json','spec/pacts/foo-bar.json']}

          before do
            allow(pacts_client).to receive(:publish).with(
              pact_hash: pact_hash,
              consumer_version: consumer_version
            ).and_raise("an error")

            allow($stderr).to receive(:puts)
          end

          it "logs an message to stderr" do
            expect($stderr).to receive(:puts).with(/Failed to publish Consumer\/Provider pact/)
            subject.call
          end

          it "continues publishing the rest" do
            expect(pacts_client).to receive(:publish).with(
              pact_hash: pact_hash_2, consumer_version: consumer_version)
            subject.call
          end

          it "returns false" do
            expect(subject.call).to be false
          end
        end

        context "when no pact files are specified" do
          let(:pact_file_paths) { [] }
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

        context "when consumer_version has a new line" do
          let(:consumer_version) { "1\n" }

          it "strips the new line" do
            expect(pacts_client).to receive(:publish).with(pact_hash: pact_hash, consumer_version: "1")
            subject.call
          end
        end

        context "when pact_broker_base_url is blank" do
          let(:pact_broker_base_url) { " " }
          it "raises a validation errror" do
            expect { subject.call }.to raise_error(/Please specify the pact_broker_base_url/)
          end
        end

        context "when a tag is provided" do
          let(:tags) { ["dev"] }

          it "tags the consumer version" do
            expect(pact_versions_client).to receive(:tag).with({pacticipant: "Consumer",
              version: consumer_version, tag: "dev"})
            subject.call
          end

          it "tags the version before publishing the pact so that there aren't timing issues retrieving pacts by tag" do
            expect(pact_versions_client).to receive(:tag).ordered
            expect(pacts_client).to receive(:publish).ordered
            subject.call
          end

          context "when the tag has a new line on the end of it" do
            let(:tags) { ["foo\n"] }

            it "strips the newline" do
              expect(pact_versions_client).to receive(:tag).with({pacticipant: "Consumer",
                version: consumer_version, tag: "foo"})
              subject.call
            end
          end

          context "when an error occurs tagging the pact" do

            before do
              allow(pact_versions_client).to receive(:tag).and_raise("an error")
              allow(Retry).to receive(:sleep)
              allow($stderr).to receive(:puts)
            end

            it "retries multiple times" do
              expect(pact_versions_client).to receive(:tag).exactly(3).times
              subject.call
            end

            it "returns false" do
              expect(subject.call).to eq false
            end
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
