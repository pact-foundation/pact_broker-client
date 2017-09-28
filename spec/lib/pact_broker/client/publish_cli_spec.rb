require 'pact_broker/client/publish_cli'

module PactBroker
  module Client
    describe PublishCLI do


      describe ".publish" do
        before do
          allow(PactBroker::Client::PublishPacts).to receive(:call).and_return(true)
        end

        let(:minimum_valid_options) do
          {
            pact_dir: 'spec/pacts',
            consumer_version: '1.2.3',
            broker_base_url: 'http://pact-broker'
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

      describe ".turn_muliple_tag_options_into_array" do
        it "turns '--tag foo --tag bar' into '--tag foo bar'" do
          input = %w{--ignore this --tag foo --tag bar --ignore --that}
          output = %w{--ignore this --ignore --that --tag foo bar}
          expect(PublishCLI.turn_muliple_tag_options_into_array(input)).to eq output
        end

        it "turns '-t foo -t bar' into '--tag foo bar'" do
          input = %w{--ignore this -t foo -t bar --ignore --that}
          output = %w{--ignore this --ignore --that --tag foo bar}
          expect(PublishCLI.turn_muliple_tag_options_into_array(input)).to eq output
        end

        it "doesn't change anything when there are no --tag options" do
          input = %w{--ignore this --taggy foo --taggy bar --ignore --that}
          expect(PublishCLI.turn_muliple_tag_options_into_array(input)).to eq input
        end

        it "return an empty array when given an empty array" do
          input = []
          expect(PublishCLI.turn_muliple_tag_options_into_array(input)).to eq input
        end
      end
    end
  end
end
