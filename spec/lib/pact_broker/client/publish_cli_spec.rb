require 'pact_broker/client/publish_cli'

module PactBroker
  module Client
    describe PublishCLI do

      before do
        allow(PactBroker::Client::PublishPacts).to receive(:call).and_return(true)
      end

      describe "#publish" do
        let(:minimum_valid_options) do
          {
            pact_dir: 'spec/pacts',
            consumer_version: '1.2.3',
            base_url: 'http://pact-broker'
          }
        end

        context "with minimum valid options" do
          before do
            subject.options = minimum_valid_options
          end

          it "invokes the PublishPacts command" do
            expect(PactBroker::Client::PublishPacts).to receive(:call).with(
              "http://pact-broker",
              Rake::FileList["spec/pacts/*.json"],
              "1.2.3",
              [],
              {}
            )
            subject.publish
          end
        end

        context "with a tag" do
          before do
            subject.options = minimum_valid_options.merge(tag: 'foo')
          end

          it "passes in the tag" do
            expect(PactBroker::Client::PublishPacts).to receive(:call).with(
              anything,
              anything,
              anything,
              ['foo'],
              anything
            )
            subject.publish
          end
        end

        context "with basic auth options specified" do
          before do
            subject.options = minimum_valid_options.merge(username: 'foo', password: 'bar')
          end

          it "passes in the basic auth options" do
            expect(PactBroker::Client::PublishPacts).to receive(:call).with(
              anything,
              anything,
              anything,
              anything,
              {username: 'foo', password: 'bar'}
            )
            subject.publish
          end
        end

        context "when an error occurs publishing" do
          before do
            allow(PactBroker::Client::PublishPacts).to receive(:call).and_return(false)
            subject.options = minimum_valid_options
          end

          it "raises a PactBroker::Client::PactPublicationError" do
            expect { subject.publish }.to raise_error PactBroker::Client::PactPublicationError
          end
        end
      end
    end
  end
end
