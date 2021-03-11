require_relative 'pact_helper'
require 'pact_broker/client/pacticipants/create'

RSpec.describe "creating or updating a pacticipant", pact: true do
  include_context "pact broker"
  include PactBrokerPactHelperMethods

  before do
    index_links = {
      'pb:pacticipants' => Pact.term('http://localhost:1234/pacticipants', %r{http://.*}),
      'pb:pacticipant' => Pact.term('http://localhost:1234/pacticipants/{pacticipant}', %r{http://.*\{pacticipant\}}),
    }
    mock_pact_broker_index_with_relations(self, index_links, "the pacticipant relations are present")
  end

  let(:params) do
    {
      name: "Foo",
      repository_url: "http://foo"
    }
  end

  let(:request_body) { { name: "Foo", repositoryUrl: "http://foo" } }


  let(:response_status) { 201 }
  let(:create_success_response) do
    {
      status: response_status,
      headers: pact_broker_response_headers,
      body: {
        name: "Foo",
        repositoryUrl: "http://foo",
        _links: {
          self: {
            href: Pact.term('http://localhost:1234/pacticipants/Foo', %r{http://.*}),
          }
        }
      }
    }
  end

  let(:get_success_response) do
    {
      status: 200,
      headers: pact_broker_response_headers,
      body: {
        _links: {
          self: {
            href: Pact.term('http://localhost:1234/pacticipants/Foo', %r{http://.*}),
          }
        }
      }
    }
  end

  let(:pact_broker_client_options) { {} }

  subject { PactBroker::Client::Pacticipants2::Create.call(params, broker_base_url, pact_broker_client_options) }

  context "when the pacticipant does not already exist" do
    before do
      pact_broker
        .upon_receiving("a request to retrieve a pacticipant")
        .with(
            method: :get,
            path: '/pacticipants/Foo',
            headers: get_request_headers)
        .will_respond_with(status: 404)

      pact_broker
        .upon_receiving("a request to create a pacticipant")
        .with(
            method: :post,
            path: '/pacticipants',
            headers: post_request_headers,
            body: request_body)
        .will_respond_with(create_success_response)
    end

    it "returns a CommandResult with success = true" do
      expect(subject).to be_a PactBroker::Client::CommandResult
      expect(subject.success).to be true
      expect(subject.message).to eq "Pacticipant \"Foo\" created"
    end
  end

  context "when the pacticipant does already exist" do
    before do
      pact_broker
        .given("a pacticipant with name Foo exists")
        .upon_receiving("a request to retrieve a pacticipant")
        .with(
          method: :get,
          path: '/pacticipants/Foo',
          headers: get_request_headers)
        .will_respond_with(get_success_response)

      pact_broker
        .given("a pacticipant with name Foo exists")
        .upon_receiving("a request to update a pacticipant")
        .with(
          method: :patch,
          path: '/pacticipants/Foo',
          headers: old_patch_request_headers,
          body: request_body)
        .will_respond_with(create_success_response)
    end

    let(:response_status) { 200 }

    it "returns a CommandResult with success = true" do
      expect(subject).to be_a PactBroker::Client::CommandResult
      expect(subject.success).to be true
      expect(subject.message).to eq "Pacticipant \"Foo\" updated"
    end
  end
end
