require 'pact_broker/client/pacticipants/create'

module PactBroker
  module Client
    module Pacticipants2
      describe Create do
        describe ".call" do
          before do
            allow_any_instance_of(PactBroker::Client::Hal::HttpClient).to receive(:sleep)
          end
          let(:pact_broker_client_options) { { pact_broker_base_url: broker_base_url} }
          let(:broker_base_url) { "http://url" }
          let(:params) { { name: 'Foo' } }

          subject { Create.call(params, {}, pact_broker_client_options)}

          context "when there is an http error" do
            let!(:index_request) do
              stub_request(:get, broker_base_url).to_return(status: 500, body: 'some error', headers: { "Content-Type" => "application/hal+json" }  )
            end

            it "returns a failure result" do
              expect(subject.success).to be false
              expect(subject.message).to include 'some error'
            end
          end
        end
      end
    end
  end
end
