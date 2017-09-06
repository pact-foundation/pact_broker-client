require 'spec_helper'
require 'pact_broker/client/tasks/publication_task'
require 'pact_broker/client/publish_pacts'

module PactBroker::Client

  describe PublicationTask do

    before do
      @consumer_version = "1.2.3"
    end

    let(:publish_pacts) { instance_double("PactBroker::ClientSupport::PublishPacts")}
    let(:pact_file_list) { ['spec/pact/consumer-provider.json'] }

    before do
      allow(PactBroker::Client::PublishPacts).to receive(:new).and_return(publish_pacts)
      allow(FileList).to receive(:[]).with(pattern).and_return(pact_file_list)
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
          expect(PactBroker::Client::PublishPacts).to receive(:new).with('http://pact-broker', pact_file_list, '1.2.3', [], {}).and_return(publish_pacts)
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
        expect(PactBroker::Client::PublishPacts).to receive(:new).with('http://pact-broker', pact_file_list, '1.2.3', [], {write: :merge}).and_return(publish_pacts)
        expect(publish_pacts).to receive(:call).and_return(true)
        Rake::Task['pact:publish:merge'].execute
      end
    end

    describe "custom task" do

      before :all do
        @pact_broker_base_url = "http://some-host"
        @pattern = "pact/*.json"
        @pact_broker_basic_auth = { username: 'user', password: 'pass'}
        @tag = "dev"
        PactBroker::Client::PublicationTask.new(:custom) do | task |
          task.consumer_version = '1.2.3'
          task.tag = @tag
          task.pact_broker_base_url = @pact_broker_base_url
          task.pattern = @pattern
          task.pact_broker_basic_auth = @pact_broker_basic_auth
        end
      end

      let(:pattern) { @pattern }

      it "invokes PublishPacts with the customised values" do
        expect(PactBroker::Client::PublishPacts).to receive(:new).with(@pact_broker_base_url, pact_file_list, '1.2.3', [@tag], {basic_auth: @pact_broker_basic_auth})
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
