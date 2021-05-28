require 'service_providers/pact_helper'
require 'pact_broker/client/environments/create_environment'

RSpec.describe "create an environment", pact: true, skip: true do
  include_context "pact broker"
  include PactBrokerPactHelperMethods

  let(:params) do
    {
      name: "test",
      display_name: "Test",
      production: false,
      contact_name: "Foo team",
      contact_email_address: "foo@bar.com"

    }
  end
  let(:pact_broker_client_options) { {} }
  let(:request_body) do
    {
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
  end

  subject { PactBroker::Client::Environments::CreateEnvironment.call(params, broker_base_url, pact_broker_client_options) }

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

  def mock_environment_creation_request
    pact_broker
      .upon_receiving("a request to create an environment")
      .with(
        method: "POST",
        path: "/HAL-REL-PLACEHOLDER-PB-ENVIRONMENTS",
        headers: post_request_headers,
        body: request_body
      )
      .will_respond_with(
        status: 201,
        headers: pact_broker_response_headers,
        body: request_body.merge("uuid" => Pact.like("ffe683ef-dcd7-4e4f-877d-f6eb3db8e86e"))
      )
  end

  it "returns a success result" do
    mock_index
    mock_environment_creation_request
    expect(subject.success).to be true
    expect(subject.message).to include "Created test environment in the Pact Broker with UUID ffe683ef-dcd7-4e4f-877d-f6eb3db8e86e"
  end
end
