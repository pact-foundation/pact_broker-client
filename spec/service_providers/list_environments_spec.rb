require 'service_providers/pact_helper'
require 'pact_broker/client/environments/list_environments'

RSpec.describe "list environments", pact: true, skip: true do
  include_context "pact broker"
  include PactBrokerPactHelperMethods

  let(:params) { { output: output } }
  let(:output) { "text" }
  let(:pact_broker_client_options) { {} }
  let(:response_body) do
    {
      _embedded: {
        environments: Pact.each_like(
          {
            uuid: "78e85fb2-9df1-48da-817e-c9bea6294e01",
            name: "test",
            displayName: "Test",
            production: false,
            contacts: [{
              name: "Foo team",
              details: {
                emailAddress: "foo@bar.com"
              }
            }]
          }
        )
      }
    }
  end

  subject { PactBroker::Client::Environments::ListEnvironments.call(params, broker_base_url, pact_broker_client_options) }

  def mock_index
    pact_broker
      .given("the pb:environments relation exists in the index resource")
      .upon_receiving("a request for the index resource")
      .with(
        method: "GET",
        path: '/',
        headers: get_request_headers).
      will_respond_with(
        status: 200,
        headers: pact_broker_response_headers,
        body: {
          _links: {
            :'pb:environments' => {
              href: placeholder_url_term("pb:environments")
            }
          }
        }
      )
  end

  def mock_get_environments
    pact_broker
      .given("an environment exists")
      .upon_receiving("a request to list the environments")
      .with(
        method: "GET",
        path: "/HAL-REL-PLACEHOLDER-PB-ENVIRONMENTS",
        headers: get_request_headers
      )
      .will_respond_with(
        status: 200,
        headers: pact_broker_response_headers,
        body: response_body
      )
  end

  it "returns a success result" do
    mock_index
    mock_get_environments
    expect(subject.success).to be true
    Approvals.verify(subject.message, :name => "list_environments", format: :txt)
  end
end
