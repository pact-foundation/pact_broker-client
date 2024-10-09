require "pact_broker/client/cli/broker"
require 'ostruct'

module PactBroker
  module Client
    module CLI
      describe Broker do
        before do
          subject.options = OpenStruct.new(minimum_valid_options)
          allow($stdout).to receive(:puts)
          allow($stderr).to receive(:puts)
          allow(Retry).to receive(:sleep)
        end

        let(:minimum_valid_options) do
          {
            broker_base_url: 'http://pact-broker',
            output: 'table',
            verbose: 'verbose',
            retry_while_unknown: 1,
            retry_interval: 2,
            limit: 1000,
            dry_run: false
          }
        end

        let(:invoke_can_i_merge) { subject.can_i_merge }

        it "sends a matrix query" do
          stub_request(:get, "http://pact-broker/matrix?latest=true&latestby=cvp&mainBranch=true&q%5B%5D%5Bpacticipant%5D=Foo&q%5B%5D%5Bversion%5D=1").
            with(
              headers: {
              'Accept'=>'application/hal+json',
              }).
            to_return(status: 200, body: File.read("spec/support/matrix.json"), headers: { "Content-Type" => "application/hal+json" })     

          stub_const("ARGV", %w[--pacticipant Foo --version 1])
          expect($stdout).to receive(:puts).with(/Computer says yes/)
          invoke_can_i_merge
        end


        it "ignores pacticipant if --ignore flag is provided" do
          stub_request(:get, "http://pact-broker/matrix?latest=true&latestby=cvp&mainBranch=true&q%5B%5D%5Bpacticipant%5D=Bar&q%5B%5D%5Bversion%5D=3.4.5&ignore%5B%5D%5Bpacticipant%5D=Foo").
            with(
              headers: {
              'Accept'=>'application/hal+json',
              }).
            to_return(status: 200, body: File.read("spec/support/matrix.json"), headers: { "Content-Type" => "application/hal+json" })     
          stub_const("ARGV", %w[--pacticipant Bar --version 3.4.5 --ignore Foo])
          expect($stdout).to receive(:puts).with(/Computer says yes/)
          invoke_can_i_merge
        end
      end
    end
  end
end
