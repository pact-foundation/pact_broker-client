require_relative '../../../pact_ruby_v2_spec_helper'
require "pact_broker/client/branches/delete_branch"

RSpec.describe "delete a branch", pact: true do
  pact_broker # our "Pact Broker" service Pact provider helper
  include_context "pact broker"
  include_context "pact broker - pact-ruby-v2"
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

  let(:pact_broker_base_url) { "http://127.0.0.1:9999" }
  let(:pact_broker_client_options) { { pact_broker_base_url: pact_broker_base_url } }
  let(:response_headers) { { "Content-Type" => "application/hal+json"} }
  let(:verbose) { false }

  subject { PactBroker::Client::Branches::DeleteBranch.call(params, options, pact_broker_client_options) }

  def mock_index
    new_interaction
      .given("the pb:pacticipant-branch relation exists in the index resource")
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
            :'pb:pacticipant-branch' => {
              href: placeholder_url_term("pb:pacticipant-branch", ["pacticipant", "branch"], pact_broker_base_url)
            }
          }
        }
      )
  end

  def mock_branch_delete_request
    new_interaction
      .given("a branch named main exists for pacticipant Foo")
      .upon_receiving("a request to delete a pacticipant branch")
      .with_request(
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
    execute_http_pact do |mock_server|
      expect(subject.success).to be true
    end
  end
end
