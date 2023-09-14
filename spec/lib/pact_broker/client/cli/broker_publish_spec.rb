require 'pact_broker/client/cli/broker'
require 'pact_broker/client/publish_pacts'
require 'pact_broker/client/git'

module PactBroker::Client::CLI
  describe Broker do
    describe '.broker' do
      before do
        allow(PactBroker::Client::PublishPacts).to receive(:call).and_return(result)
        allow(PactBroker::Client::Git).to receive(:branch).and_return('bar')
        allow(PactBroker::Client::Git).to receive(:commit).and_return('6.6.6')
        subject.options = OpenStruct.new(minimum_valid_options)
        allow($stdout).to receive(:puts)
      end

      let(:success) { true }
      let(:result) { instance_double(PactBroker::Client::CommandResult, success: success, message: "message")}
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
            { number: "1.2.3", tags: [], version_required: false },
            {},
            { pact_broker_base_url: 'http://pact-broker' }
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

      context "with an invalid argument specified that gets interpreted as a path" do
        let(:file_list) { ['--wrong'] }

        it "raises a more helpful error" do
          expect{ invoke_broker }.to raise_error(Thor::Error, 'ERROR: pact-broker publish was called with invalid arguments ["--wrong"]')
        end
      end

      context "when a specified file does not exist" do
        let(:file_list) { ['no-existy'] }

        it "raises a more helpful error" do
          expect{ invoke_broker }.to raise_error(Thor::Error, /Specified pact file 'no-existy' does not exist/)
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
            hash_including(tags: ['foo']),
            anything,
            anything
          )
          invoke_broker
        end
      end

      context "with tag-with-git-branch" do
        before do
          subject.options = OpenStruct.new(
            minimum_valid_options.merge(tag_with_git_branch: true, tag: ['foo'])
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
            hash_including(tags: ['foo', 'bar']),
            anything,
            anything
          )
          invoke_broker
        end
      end

      context "with a branch specified" do
        before do
          subject.options = OpenStruct.new(
            minimum_valid_options.merge(branch: "main")
          )
        end

        it "passes in the branch option" do
          expect(PactBroker::Client::PublishPacts).to receive(:call).with(
            anything,
            anything,
            hash_including(branch: "main", version_required: true),
            anything,
            anything
          )
          invoke_broker
        end
      end

      context "with --auto-detect-version-properties on by default" do
        before do
          subject.options = OpenStruct.new(
            minimum_valid_options.merge(auto_detect_version_properties: true, consumer_app_version: nil)
          )
          allow(subject).to receive(:explict_auto_detect_version_properties).and_return(false)
        end

        it "determines the git branch name" do
          expect(PactBroker::Client::Git).to receive(:branch).with(raise_error: false)
          invoke_broker
        end

        it "passes in the auto detected branch option with version_required: false" do
          expect(PactBroker::Client::PublishPacts).to receive(:call).with(
            anything,
            anything,
            hash_including(branch: "bar", version_required: false),
            anything,
            anything
          )
          invoke_broker
        end
        it 'determines the git commit sha' do
          expect(PactBroker::Client::Git).to receive(:commit).with(raise_error: true)
          invoke_broker
        end

        it 'passes in the auto detected commit sha with version_required: false' do
          expect(PactBroker::Client::PublishPacts).to receive(:call).with(
            anything,
            anything,
            hash_including(number: '6.6.6', version_required: false),
            anything,
            anything
          )
          invoke_broker
        end
      end

      context "with --auto-detect-version-properties specified explicitly" do
        before do
          subject.options = OpenStruct.new(
            minimum_valid_options.merge(auto_detect_version_properties: true, consumer_app_version: nil)
          )
          allow(subject).to receive(:explict_auto_detect_version_properties).and_return(true)
        end

        it "determines the git branch name" do
          expect(PactBroker::Client::Git).to receive(:branch).with(raise_error: true)
          invoke_broker
        end

        it "passes in the auto detected branch option with version_required: true" do
          expect(PactBroker::Client::PublishPacts).to receive(:call).with(
            anything,
            anything,
            hash_including(branch: "bar", version_required: true),
            anything,
            anything
          )
          invoke_broker
        end

        it 'determines the commit sha' do
          expect(PactBroker::Client::Git).to receive(:commit).with(raise_error: true)
          invoke_broker
        end

        it 'passes in the auto detected commit sha option with version_required: true' do
          expect(PactBroker::Client::PublishPacts).to receive(:call).with(
            anything,
            anything,
            hash_including(number: '6.6.6', version_required: true),
            anything,
            anything
          )
          invoke_broker
        end

        context "with the branch specified as well" do
          before do
            subject.options = OpenStruct.new(
              minimum_valid_options.merge(branch: "specified-branch", auto_detect_version_properties: true)
            )
          end

          it "uses the specified branch" do
            expect(PactBroker::Client::PublishPacts).to receive(:call).with(
              anything,
              anything,
              hash_including(branch: "specified-branch", version_required: true),
              anything,
              anything
            )
            invoke_broker
          end
        end
      end

      context "with the build_url specified" do
        before do
          subject.options = OpenStruct.new(
            minimum_valid_options.merge(build_url: "http://ci")
          )
        end

        it "passes in the branch option" do
          expect(PactBroker::Client::PublishPacts).to receive(:call).with(
            anything,
            anything,
            hash_including(build_url: "http://ci"),
            anything,
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
            hash_including(basic_auth: { username: 'foo', password: 'bar' })
          )
          invoke_broker
        end
      end

      context "with basic auth and a token specified" do
        before do
          subject.options = OpenStruct.new(
            minimum_valid_options.merge(broker_username: 'foo', broker_password: 'bar', broker_token: 'foo')
          )
        end

        it "raises an error" do
          expect { invoke_broker }.to raise_error AuthError, /both/
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
        let(:success) { false }

        it "raises a SystemExit" do
          expect { invoke_broker }.to raise_error SystemExit
        end
      end
    end
  end
end
