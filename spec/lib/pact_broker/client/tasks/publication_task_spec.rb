require 'spec_helper'
require 'pact_broker/client/tasks/publication_task'
require 'pact_broker/client/publish_pacts'
require 'pact_broker/client/command_result'

module PactBroker::Client
  describe PublicationTask do
    before do
      @consumer_version = "1.2.3"
    end

    let(:publish_pacts) { instance_double("PactBroker::ClientSupport::PublishPacts", call: result)}
    let(:pact_file_list) { ['spec/pact/consumer-provider.json'] }
    let(:success) { true }
    let(:result) { instance_double(PactBroker::Client::CommandResult, success: success, message: "message")}

    before do
      allow(PactBroker::Client::PublishPacts).to receive(:new).and_return(publish_pacts)
      allow(FileList).to receive(:[]).with(pattern).and_return(pact_file_list)
      allow(PactBroker::Client::Git).to receive(:branch).and_return('foo')
      allow(PactBroker::Client::Git).to receive(:commit).and_return('6.6.6')
      allow(PactBroker::Client::Git).to receive(:build_url).and_return("build_url")
      allow($stdout).to receive(:puts)
    end

    let(:pattern) { "spec/pacts/*.json" }

    describe "default task" do
      before :all do
        PactBroker::Client::PublicationTask.new do | task |
          task.consumer_version = '1.2.3'
        end
      end

      context "when pacts are succesfully published" do
        it "invokes PublishPacts with the default values" do
          expect(PactBroker::Client::PublishPacts).to receive(:new).with('http://pact-broker', pact_file_list, { number: '1.2.3', branch: "foo", tags: [] }, {}, {}).and_return(publish_pacts)
          expect(publish_pacts).to receive(:call).and_return(result)
          Rake::Task['pact:publish'].execute
        end
      end

      context "when a pact fails to be published" do
        let(:success) { false }

        it "raises an error" do
          expect { Rake::Task['pact:publish'].execute }.to raise_error("One or more pacts failed to be published")
        end
      end
    end

    describe "merge method configuration" do
      before :all do
        PactBroker::Client::PublicationTask.new(:merge) do | task |
          task.consumer_version = '1.2.3'
          task.write_method = :merge
        end
      end

      it "invokes PublishPacts with the write method set" do
        expect(PactBroker::Client::PublishPacts).to receive(:new).with('http://pact-broker', pact_file_list, { number: "1.2.3", branch: "foo", tags: [] }, {}, {write: :merge}).and_return(publish_pacts)
        expect(publish_pacts).to receive(:call).and_return(result)
        Rake::Task['pact:publish:merge'].execute
      end
    end

    context "when tag_with_git_branch is true" do
      before :all do
        PactBroker::Client::PublicationTask.new(:git_branch) do | task |
          task.consumer_version = '1.2.3'
          task.tag_with_git_branch = true
          task.auto_detect_version_properties = false
          task.tags = ['bar']
        end
      end

      it "gets the git branch name" do
        expect(PactBroker::Client::Git).to receive(:branch).with(raise_error: true)
        Rake::Task['pact:publish:git_branch'].execute
      end

      it "invokes PublishPacts with the git branch name as a tag" do
        expect(PactBroker::Client::PublishPacts).to receive(:new).with(anything, anything, hash_including(tags: ['bar', 'foo']), anything, anything).and_return(publish_pacts)
        Rake::Task['pact:publish:git_branch'].execute
      end
    end

    context "when auto_detect_version_properties is explicitly set to true" do
      before :all do
        PactBroker::Client::PublicationTask.new(:git_branch_auto_detect_true) do | task |
          task.auto_detect_version_properties = true
        end
      end

      # Don't usually put 3 expects into the one it block, but if I separate them,
      # only the first it block passes for some reason that I can't work out.
      it "gets the commit, build_url and branch" do
        expect(PactBroker::Client::Git).to receive(:commit).with(raise_error: true)
        expect(PactBroker::Client::Git).to receive(:build_url)
        expect(PactBroker::Client::Git).to receive(:branch).with(raise_error: true)
        Rake::Task['pact:publish:git_branch_auto_detect_true'].execute
      end

      it "invokes PublishPacts with the branch name and build URL" do
        expect(PactBroker::Client::PublishPacts).to receive(:new).with(anything, anything, hash_including(number: "6.6.6", branch: "foo", build_url: "build_url"), anything, anything).and_return(publish_pacts)
        Rake::Task['pact:publish:git_branch_auto_detect_true'].execute
      end
    end

    context "when auto_detect_version_properties is explicitly set to true and the auto detectable attributes are specified" do
      before :all do
        PactBroker::Client::PublicationTask.new(:auto_detect_true_with_attributes_specified) do | task |
          task.auto_detect_version_properties = true
          task.consumer_version = '1.2.3'
          task.branch = "feat/foo"
          task.consumer_version = "3"
          task.build_url = "some_build"
        end
      end

      it "does not get the commit, branch or build URL from Git" do
        expect(PactBroker::Client::Git).to_not receive(:commit)
        expect(PactBroker::Client::Git).to_not receive(:build_url)
        expect(PactBroker::Client::Git).to_not receive(:branch)
        Rake::Task['pact:publish:auto_detect_true_with_attributes_specified'].execute
      end

      it "invokes PublishPacts with the specified attributes" do
        expect(PactBroker::Client::PublishPacts).to receive(:new).with(anything, anything, hash_including(number: "3", branch: "feat/foo", build_url: "some_build"), anything, anything).and_return(publish_pacts)
        Rake::Task['pact:publish:auto_detect_true_with_attributes_specified'].execute
      end
    end

    context "when auto_detect_version_properties is explicitly set to false" do
      before :all do
        PactBroker::Client::PublicationTask.new(:auto_detect_false) do | task |
          task.auto_detect_version_properties = false
          task.consumer_version = '1.2.3'
          task.branch = "feat/foo"
          task.consumer_version = "3"
          task.build_url = "some_build"
        end
      end

      it "does not get the commit, branch or build URL from Git" do
        expect(PactBroker::Client::Git).to_not receive(:commit)
        expect(PactBroker::Client::Git).to_not receive(:build_url)
        expect(PactBroker::Client::Git).to_not receive(:branch)
        Rake::Task['pact:publish:auto_detect_false'].execute
      end

      it "invokes PublishPacts with the specified attributes" do
        expect(PactBroker::Client::PublishPacts).to receive(:new).with(anything, anything, hash_including(number: "3", branch: "feat/foo", build_url: "some_build"), anything, anything).and_return(publish_pacts)
        Rake::Task['pact:publish:auto_detect_false'].execute
      end
    end

    context "when auto_detect_version_properties is left as its default and the branch is not specified" do
      before :all do
        PactBroker::Client::PublicationTask.new(:auto_detect_default) do | task |
          task.consumer_version = '1.2.3'
        end
      end

      it "gets the git branch name but won't raise an error if it can't be determined" do
        expect(PactBroker::Client::Git).to receive(:branch).with(raise_error: false)
        Rake::Task['pact:publish:auto_detect_default'].execute
      end

      it "invokes PublishPacts with the branch name if found" do
        expect(PactBroker::Client::PublishPacts).to receive(:new).with(anything, anything, hash_including(branch: "foo"),anything, anything).and_return(publish_pacts)
        Rake::Task['pact:publish:auto_detect_default'].execute
      end
    end

    describe "custom task" do
      before :all do
        @pact_broker_base_url = "http://some-host"
        @pattern = "pact/*.json"
        @pact_broker_basic_auth = { username: 'user', password: 'pass' }
        @pact_broker_token = 'token'
        @tag = "dev"
        PactBroker::Client::PublicationTask.new(:custom) do | task |
          task.consumer_version = '1.2.3'
          task.tag = @tag
          task.pact_broker_base_url = @pact_broker_base_url
          task.pattern = @pattern
          task.pact_broker_basic_auth = @pact_broker_basic_auth
          task.pact_broker_token = @pact_broker_token
        end
      end

      let(:pattern) { @pattern }

      it "invokes PublishPacts with the customised values" do
        expect(PactBroker::Client::PublishPacts).to receive(:new).with(
          @pact_broker_base_url,
          pact_file_list,
          { number: "1.2.3", tags: [@tag], branch: "foo" },
          {},
          { basic_auth: @pact_broker_basic_auth, token: @pact_broker_token }
        )
        expect(publish_pacts).to receive(:call).and_return(result)
        Rake::Task['pact:publish:custom'].execute
      end
    end

    describe "timing of block execution" do
      before :all do
        PactBroker::Client::PublicationTask.new(:exception) do | task |
          raise 'A contrived exception'
        end
      end

      it "does not execute the block passed to the publication task until the task is called" do
        expect{ Rake::Task['pact:publish:exception'].execute }.to raise_error 'A contrived exception'
      end
    end
  end
end
