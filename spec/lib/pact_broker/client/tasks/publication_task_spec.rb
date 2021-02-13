require 'spec_helper'
require 'pact_broker/client/tasks/publication_task'
require 'pact_broker/client/publish_pacts'

module PactBroker::Client
  describe PublicationTask do

    before do
      @consumer_version = "1.2.3"
    end

    let(:publish_pacts) { instance_double("PactBroker::ClientSupport::PublishPacts", call: true)}
    let(:pact_file_list) { ['spec/pact/consumer-provider.json'] }

    before do
      allow(PactBroker::Client::PublishPacts).to receive(:new).and_return(publish_pacts)
      allow(FileList).to receive(:[]).with(pattern).and_return(pact_file_list)
      allow(PactBroker::Client::Git).to receive(:branch).and_return('foo')
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
          expect(PactBroker::Client::PublishPacts).to receive(:new).with('http://pact-broker', pact_file_list, { number: '1.2.3', branch: "foo", tags: [], version_required: false}, {}).and_return(publish_pacts)
          expect(publish_pacts).to receive(:call).and_return(true)
          Rake::Task['pact:publish'].execute
        end
      end

      context "when a pact fails to be published" do
        it "raises an error" do
          expect(publish_pacts).to receive(:call).and_return(false)
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
        expect(PactBroker::Client::PublishPacts).to receive(:new).with('http://pact-broker', pact_file_list, { number: "1.2.3", branch: "foo", tags: [], version_required: false }, {write: :merge}).and_return(publish_pacts)
        expect(publish_pacts).to receive(:call).and_return(true)
        Rake::Task['pact:publish:merge'].execute
      end
    end

    context "when tag_with_git_branch is true" do
      before :all do
        PactBroker::Client::PublicationTask.new(:git_branch) do | task |
          task.consumer_version = '1.2.3'
          task.tag_with_git_branch = true
          task.auto_detect_branch = false
          task.tags = ['bar']
        end
      end

      it "gets the git branch name" do
        expect(PactBroker::Client::Git).to receive(:branch).with(raise_error: true)
        Rake::Task['pact:publish:git_branch'].execute
      end

      it "invokes PublishPacts with the git branch name as a tag" do
        expect(PactBroker::Client::PublishPacts).to receive(:new).with(anything, anything, hash_including(tags: ['bar', 'foo']), anything).and_return(publish_pacts)
        Rake::Task['pact:publish:git_branch'].execute
      end
    end

    context "when auto_detect_branch is explicitly set to true" do
      before :all do
        PactBroker::Client::PublicationTask.new(:git_branch_auto_detect_true) do | task |
          task.consumer_version = '1.2.3'
          task.auto_detect_branch = true
        end
      end

      it "gets the git branch name" do
        expect(PactBroker::Client::Git).to receive(:branch).with(raise_error: true)
        Rake::Task['pact:publish:git_branch_auto_detect_true'].execute
      end

      it "invokes PublishPacts with the branch name" do
        expect(PactBroker::Client::PublishPacts).to receive(:new).with(anything, anything, hash_including(branch: "foo"), anything).and_return(publish_pacts)
        Rake::Task['pact:publish:git_branch_auto_detect_true'].execute
      end
    end

    context "when auto_detect_branch is explicitly set to true and the branch is specified" do
      before :all do
        PactBroker::Client::PublicationTask.new(:git_branch_auto_detect_true_with_branch) do | task |
          task.consumer_version = '1.2.3'
          task.auto_detect_branch = true
          task.branch = "main"
        end
      end

      it "does not get the branch name" do
        expect(PactBroker::Client::Git).to_not receive(:branch)
        Rake::Task['pact:publish:git_branch_auto_detect_true_with_branch'].execute
      end

      it "invokes PublishPacts with the specified branch name" do
        expect(PactBroker::Client::PublishPacts).to receive(:new).with(anything, anything, hash_including(branch: "main"), anything).and_return(publish_pacts)
        Rake::Task['pact:publish:git_branch_auto_detect_true_with_branch'].execute
      end
    end

    context "when auto_detect_branch is explicitly set to false" do
      before :all do
        PactBroker::Client::PublicationTask.new(:git_branch_auto_detect_false) do | task |
          task.consumer_version = '1.2.3'
          task.auto_detect_branch = false
        end
      end

      it "does not get the git branch name" do
        expect(PactBroker::Client::Git).to_not receive(:branch)
        Rake::Task['pact:publish:git_branch_auto_detect_false'].execute
      end

      it "invokes PublishPacts without the branch name" do
        expect(PactBroker::Client::PublishPacts).to receive(:new).with(anything, anything, hash_not_including(branch: "foo"), anything).and_return(publish_pacts)
        Rake::Task['pact:publish:git_branch_auto_detect_false'].execute
      end
    end

    context "when auto_detect_branch is left as its default" do
      before :all do
        PactBroker::Client::PublicationTask.new(:git_branch_auto_detect_default) do | task |
          task.consumer_version = '1.2.3'
        end
      end

      it "gets the git branch name" do
        expect(PactBroker::Client::Git).to receive(:branch).with(raise_error: false)
        Rake::Task['pact:publish:git_branch_auto_detect_default'].execute
      end

      it "invokes PublishPacts with the branch name" do
        expect(PactBroker::Client::PublishPacts).to receive(:new).with(anything, anything, hash_including(branch: "foo"), anything).and_return(publish_pacts)
        Rake::Task['pact:publish:git_branch_auto_detect_default'].execute
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
          { number: "1.2.3", tags: [@tag], branch: "foo", version_required: false},
          { basic_auth: @pact_broker_basic_auth, token: @pact_broker_token }
        )
        expect(publish_pacts).to receive(:call).and_return(true)
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
