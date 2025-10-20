require_relative '../../../pact_ruby_v2_spec_helper'
require 'pact_broker/client/environments/create_environment'

RSpec.describe "create an environment", pact: true do
  pact_broker
  include_context "pact broker"
  include_context "pact broker - pact-ruby-v2"
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

  let(:options) do
    {
      verbose: verbose
    }
  end
  let(:verbose) { false }
  let(:pact_broker_base_url) { "http://127.0.0.1:9999" }
  let(:pact_broker_client_options) { { pact_broker_base_url: pact_broker_base_url } }

  subject { PactBroker::Client::Environments::CreateEnvironment.call(params, options, pact_broker_client_options) }

  def mock_index
    new_interaction
      .given("the pb:environments relation exists in the index resource")
      .upon_receiving("a request for the index resource")
      .with_request(
        method: "GET",
        path: '/',
        headers: get_request_headers).
      will_respond_with(
        status: 200,
        headers: pact_broker_response_headers,
        body: {
          _links: {
            :'pb:environments' => {
              href: placeholder_url_term("pb:environments", [], pact_broker_base_url)
            }
          }
        }
      )
  end

  def mock_environment_creation_request
    new_interaction
      .upon_receiving("a request to create an environment")
      .with_request(
        method: "POST",
        path: "/HAL-REL-PLACEHOLDER-PB-ENVIRONMENTS",
        headers: post_request_headers,
        body: request_body
      )
      .will_respond_with(
        status: 201,
        headers: pact_broker_response_headers,
        body: request_body.merge("uuid" => match_type_of("ffe683ef-dcd7-4e4f-877d-f6eb3db8e86e"))
      )
  end

  it "returns a success result" do
    mock_index
    mock_environment_creation_request
    execute_http_pact do |mock_server|
      expect(subject.success).to be true
      expect(subject.message).to include "Created test environment in the Pact Broker with UUID ffe683ef-dcd7-4e4f-877d-f6eb3db8e86e"
    end
  end
end
