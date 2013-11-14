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
      PactBroker::Client::PublishPacts.stub(:new).and_return(publish_pacts)
      FileList.stub(:[]).with(pattern).and_return(pact_file_list)
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
          PactBroker::Client::PublishPacts.should_receive(:new).with('http://pact-broker', pact_file_list, '1.2.3').and_return(publish_pacts)
          publish_pacts.should_receive(:call).and_return(true)
          Rake::Task['pact:publish'].execute
        end
      end

      context "when a pact fails to be published" do
        it "raises an error" do
          publish_pacts.should_receive(:call).and_return(false)
          expect { Rake::Task['pact:publish'].execute }.to raise_error("One or more pacts failed to be published")
        end
      end
    end


    describe "custom task" do

      before :all do
        @pact_broker_base_url = "http://some-host"
        @pattern = "pact/*.json"
        PactBroker::Client::PublicationTask.new(:custom) do | task |
          task.consumer_version = '1.2.3'
          task.pact_broker_base_url = @pact_broker_base_url
          task.pattern = @pattern
        end
      end

      let(:pattern) { @pattern }

      it "invokes PublishPacts with the customised values" do
        PactBroker::Client::PublishPacts.should_receive(:new).with(@pact_broker_base_url, pact_file_list, '1.2.3')
        publish_pacts.should_receive(:call).and_return(true)
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