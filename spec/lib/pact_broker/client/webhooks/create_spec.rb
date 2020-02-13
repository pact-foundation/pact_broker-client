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
            stub_request(:get, "http://broker").with(headers: { "Authorization" => /.*/}).to_return(status: 200, body: index_body, headers: { "Content-Type" => "application/hal+json" }  )
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

          let(:pact_broker_client_options) do
            {
              token: 'token',
              verbose: 'verbose'
            }
          end

          subject { Create.call(params, "http://broker", pact_broker_client_options) }

          context "when a 405 is returned from the webhook creation request" do
            let!(:webhook_request) do
              stub_request(:post, "http://broker/webhooks").to_return(status: 405)
            end

            it "returns a result with success=false and a message" do
              expect(subject.success).to be false
              expect(subject.message).to eq Create::WEBHOOKS_WITH_OPTIONAL_PACTICICPANTS_NOT_SUPPORTED
            end
          end

          context "when a UUID is specified and index does not contain a pb:webhook relation" do
            subject { Create.call(params.merge(uuid: 'some-uuid'), "http://broker", pact_broker_client_options) }

            it "returns a result with success=false and a message" do
              expect(subject.success).to be false
              expect(subject.message).to eq Create::CREATING_WEBHOOK_WITH_UUID_NOT_SUPPORTED
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
