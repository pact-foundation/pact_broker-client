require_relative '../../../pact_ruby_v2_spec_helper'
require 'pact_broker/client/environments/list_environments'

RSpec.describe "list environments", pact: true do
  pact_broker
  include_context "pact broker"
  include_context "pact broker - pact-ruby-v2"
  include PactBrokerPactHelperMethods

  let(:params) { { output: output } }
  let(:output) { "text" }
  let(:response_body) do
    {
      _embedded: {
        environments: match_each(
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
  let(:options) do
    {
      verbose: verbose
    }
  end
  let(:verbose) { false }
  let(:pact_broker_base_url) { "http://127.0.0.1:9999" }
  let(:pact_broker_client_options) { { pact_broker_base_url: pact_broker_base_url } }
  subject { PactBroker::Client::Environments::ListEnvironments.call(params, options, pact_broker_client_options) }

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
              href: generate_mock_server_url(
                regex: ".*(\\/environments)$",
                example: "/environments"
              )
            }
          }
        }
      )
  end

  def mock_get_environments
    new_interaction
      .given("an environment exists")
      .upon_receiving("a request to list the environments")
      .with_request(
        method: "GET",
        path: "/environments",
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
    execute_http_pact do |mock_server|
      expect(subject.success).to be true
      Approvals.verify(subject.message, :name => "list_environments", format: :txt)
    end
  end
end
