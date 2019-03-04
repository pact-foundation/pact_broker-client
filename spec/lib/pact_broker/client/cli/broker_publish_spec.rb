require 'pact_broker/client/cli/broker'

module PactBroker::Client::CLI
  describe Broker do
    describe ".broker" do
      before do
        allow(PactBroker::Client::PublishPacts).to receive(:call).and_return(true)
        allow(PactBroker::Client::Git).to receive(:branch).and_return("bar")
        subject.options = OpenStruct.new(minimum_valid_options)
      end

      let(:file_list) { ["spec/support/cli_test_pacts/foo.json"] }
      let(:minimum_valid_options) do
        {
          pact_dir: 'spec/pacts',
          consumer_app_version: '1.2.3',
          broker_base_url: 'http://pact-broker'
        }
      end

      let(:invoke_broker) { subject.publish(*file_list) }

      context "with minimum valid options" do
        it "invokes the PublishPacts command" do
          expect(PactBroker::Client::PublishPacts).to receive(:call).with(
            "http://pact-broker",
            ["spec/support/cli_test_pacts/foo.json"],
            "1.2.3",
            [],
            {token: nil, verbose: nil}
          )
          invoke_broker
        end
      end

      context "with a file pattern specified" do
        let(:file_list) { ["spec/support/cli_test_pacts/*.json"] }

        it "invokes the PublishPacts command with the expanded list of files" do
          expect(PactBroker::Client::PublishPacts).to receive(:call).with(
            anything,
            ["spec/support/cli_test_pacts/bar.json", "spec/support/cli_test_pacts/foo.json"],
            anything,
            anything,
            anything
          )
          invoke_broker
        end
      end

      context "with a pact directory specified" do
        let(:file_list) { ["spec/support/cli_test_pacts"] }

        it "invokes the PublishPacts command with the list of files in the directory" do
          expect(PactBroker::Client::PublishPacts).to receive(:call).with(
            anything,
            ["spec/support/cli_test_pacts/bar.json", "spec/support/cli_test_pacts/foo.json"],
            anything,
            anything,
            anything
          )
          invoke_broker
        end
      end

      context "with a windows directory specified" do
        let(:file_list) { ['spec\\support\cli_test_pacts'] }

        it "invokes the PublishPacts command with the list of files in the directory" do
          expect(PactBroker::Client::PublishPacts).to receive(:call).with(
            anything,
            ["spec/support/cli_test_pacts/bar.json", "spec/support/cli_test_pacts/foo.json"],
            anything,
            anything,
            anything
          )
          invoke_broker
        end
      end

      context "with a tag" do
        before do
          subject.options = OpenStruct.new(minimum_valid_options.merge(tag: ['foo']))
        end

        it "passes in the tag" do
          expect(PactBroker::Client::PublishPacts).to receive(:call).with(
            anything,
            anything,
            anything,
            ['foo'],
            anything
          )
          invoke_broker
        end
      end

      context "with tag-with-git-branch" do
        before do
          subject.options = OpenStruct.new(
            minimum_valid_options.merge(tag_with_git_branch: true)
          )
        end

        it "determines the git branch name" do
          expect(PactBroker::Client::Git).to receive(:branch)
          invoke_broker
        end

        it "adds it to the list of tags when publishing" do
          expect(PactBroker::Client::PublishPacts).to receive(:call).with(
            anything,
            anything,
            anything,
            ['bar'],
            anything
          )
          invoke_broker
        end
      end

      context "with basic auth options specified" do
        before do
          subject.options = OpenStruct.new(
            minimum_valid_options.merge(broker_username: 'foo', broker_password: 'bar')
          )
        end

        it "passes in the basic auth options" do
          expect(PactBroker::Client::PublishPacts).to receive(:call).with(
            anything,
            anything,
            anything,
            anything,
            hash_including({basic_auth: {username: 'foo', password: 'bar'}})
          )
          invoke_broker
        end
      end

      context "when no pact files are specified" do
        let(:file_list) { [] }

        it "raises an error" do
          expect { invoke_broker }.to raise_error ::Thor::RequiredArgumentMissingError, "No value provided for required pact_files"
        end
      end

      context "when an error is raised publishing" do
        before do
          allow(PactBroker::Client::PublishPacts).to receive(:call).and_raise(PactBroker::Client::Error.new('foo'))
        end

        it "raises a PactPublicationError" do
          expect { invoke_broker }.to raise_error PactPublicationError, /foo/
        end
      end

      context "when the publish command is not successful" do
        before do
          allow(PactBroker::Client::PublishPacts).to receive(:call).and_return(false)
        end

        it "raises a PactPublicationError" do
          expect { invoke_broker }.to raise_error PactPublicationError
        end
      end
    end
  end
end
