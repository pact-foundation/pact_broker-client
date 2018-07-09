require 'pact_broker/client/webhooks/create'

module PactBroker
  module Client
    module Webhooks
      describe Create do
        describe ".call" do
          let(:index_body) do
            {
              "_links" => {
                "pb:webhooks" => {
                  "href" => "http://broker/webhooks"
                }
              }
            }.to_json
          end
          let!(:index_request) do
            stub_request(:get, "http://broker").to_return(status: 200, body: index_body, headers: { "Content-Type" => "application/hal+json" }  )
          end

          let!(:webhook_request) do
            stub_request(:post, "http://broker/webhooks").to_return(status: 405)
          end

          let(:params) do
            {
              http_method: "POST",
              url: "https://webhook",
              headers: { "Foo" => "bar", "Bar" => "foo"},
              username: "username",
              password: "password",
              body: "body",
              events: ["contract_content_changed"]
            }.tap { |it| Pact::Fixture.add_fixture(:create_webhook_params, it) }
          end

          subject { Create.call(params, "http://broker", {}) }

          context "when a 405 is returned from the webhook creation request" do

            it "raises an error with a message to upgrade the Pact Broker" do
              expect { subject }.to raise_error PactBroker::Client::Error, /This version of the Pact Broker/
            end
          end

          context "when a 400 is returned from the webhook creation request" do
            let!(:webhook_request) do
              stub_request(:post, "http://broker/webhooks").to_return(status: 400, body: '{"some":"error"}', headers: { "Content-Type" => "application/hal+json" })
            end

            it "returns a result with success=false" do
              expect(subject.success).to be false
              expect(subject.message).to match /400/
              expect(subject.message).to match /"some":"error"/
            end
          end
        end
      end
    end
  end
end
