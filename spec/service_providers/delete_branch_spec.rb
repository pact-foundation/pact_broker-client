require "service_providers/pact_helper"
require "pact_broker/client/branches/delete_branch"

RSpec.describe "delete a branch", pact: true do
  include_context "pact broker"
  include PactBrokerPactHelperMethods

  let(:params) do
    {
      pacticipant: "Foo",
      branch: "main",
      error_when_not_found: true
    }
  end

  let(:options) do
    {
      verbose: verbose
    }
  end

  let(:pact_broker_base_url) { pact_broker.mock_service_base_url }
  let(:pact_broker_client_options) { { pact_broker_base_url: pact_broker_base_url } }
  let(:response_headers) { { "Content-Type" => "application/hal+json"} }
  let(:verbose) { false }

  subject { PactBroker::Client::Branches::DeleteBranch.call(params, options, pact_broker_client_options) }

  def mock_index
    pact_broker
      .given("the pb:pacticipant-branch relation exists in the index resource")
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
            :'pb:pacticipant-branch' => {
              href: placeholder_url_term("pb:pacticipant-branch", ["pacticipant", "branch"], pact_broker)
            }
          }
        }
      )
  end

  def mock_branch_delete_request
    pact_broker
      .given("a branch named main exists for pacticipant Foo")
      .upon_receiving("a request to delete a pacticipant branch")
      .with(
        method: "DELETE",
        path: placeholder_path("pb:pacticipant-branch", ["Foo", "main"])
      )
      .will_respond_with(
        status: 204
      )
  end

  it "returns a success result" do
    mock_index
    mock_branch_delete_request
    expect(subject.success).to be true
  end
end
