require_relative 'pact_helper'
require 'pact_broker/client/webhooks/create'

RSpec.describe "creating a webhook", pact: true do

  include_context "pact broker"
  include PactBrokerPactHelperMethods

  let(:event_names) { %w{contract_content_changed contract_published provider_verification_published provider_verification_succeeded provider_verification_failed}  }

  let(:params) do
    {
      description: "a webhook",
      events: %w{contract_content_changed},
      http_method: "POST",
      url: "https://webhook",
      headers: { "Foo" => "bar", "Bar" => "foo"},
      username: "username",
      password: "password",
      body: body,
      consumer: "Condor",
      provider: "Pricing Service"
    }.tap { |it| Pact::Fixture.add_fixture(:create_webhook_params, it) }
  end

  let(:body) { { some: "body" }.to_json }

  let(:request_body) do
    {
      "description" => "a webhook",
      "events" => [
        "name" => "contract_content_changed"
      ],
      "request" => {
        "url" => "https://webhook",
        "method" => "POST",
        "headers" => {
          "Foo" => "bar",
          "Bar" => "foo"
        },
        "body" => {
          "some" => "body"
        },
        "username" => "username",
        "password" => "password"
      }
    }
  end

  let(:response_status) { 201 }
  let(:success_response) do
    {
      status: response_status,
      headers: pact_broker_response_headers,
      body: {
        description: Pact.like("a webhook"),
        _links: {
          self: {
            href: Pact.term('http://localhost:1234/some-url', %r{http://.*}),
            title: Pact.like("A title")
          }
        }
      }
    }
  end

  let(:pact_broker_client_options) { {} }

  subject { PactBroker::Client::Webhooks::Create.call(params, broker_base_url, pact_broker_client_options) }

  context "when a valid webhook with a JSON body is submitted" do
    before do
      pact_broker
        .given("the 'Pricing Service' and 'Condor' already exist in the pact-broker")
        .upon_receiving("a request to create a webhook with a JSON body for a consumer and provider")
        .with(
            method: :post,
            path: '/webhooks/provider/Pricing%20Service/consumer/Condor',
            headers: post_request_headers,
            body: request_body)
        .will_respond_with(success_response)
    end

    it "returns a CommandResult with success = true" do
      expect(subject).to be_a PactBroker::Client::CommandResult
      expect(subject.success).to be true
      expect(subject.message).to eq "Webhook \"a webhook\" created"
    end
  end

  context "when a valid webhook with every possible event type is sumbitted" do
    before do
      params.merge!(events: event_names)
      request_body.merge!("events" => event_names.map{ |event_name| { "name" => event_name } })

      pact_broker
        .given("the 'Pricing Service' and 'Condor' already exist in the pact-broker")
        .upon_receiving("a request to create a webhook with every possible event type")
        .with(
            method: :post,
            path: '/webhooks/provider/Pricing%20Service/consumer/Condor',
            headers: post_request_headers,
            body: request_body)
        .will_respond_with(success_response)
    end

    it "returns a CommandResult with success = true" do
      expect(subject.success).to be true
    end
  end

  context "when a valid webhook with an XML body is submitted" do
    before do
      request_body["request"]["body"] = body

      pact_broker
        .given("the 'Pricing Service' and 'Condor' already exist in the pact-broker")
        .upon_receiving("a request to create a webhook with a non-JSON body for a consumer and provider")
        .with(
            method: :post,
            path: '/webhooks/provider/Pricing%20Service/consumer/Condor',
            headers: post_request_headers,
            body: request_body)
        .will_respond_with(success_response)
    end

    let(:body) { "<xml></xml>" }

    it "returns a CommandResult with success = true" do
      expect(subject.success).to be true
    end
  end

  context "when an invalid webhook is submitted" do
    before do
      params[:url] = nil
      request_body["request"].delete("url")

      pact_broker
        .given("the 'Pricing Service' and 'Condor' already exist in the pact-broker")
        .upon_receiving("an invalid request to create a webhook for a consumer and provider")
        .with(
            method: :post,
            path: '/webhooks/provider/Pricing%20Service/consumer/Condor',
            headers: post_request_headers,
            body: request_body).
          will_respond_with(
            status: 400,
            headers: pact_broker_response_headers,
            body: {
              errors: {
                "request.url" => Pact.each_like("Some error")
              }
            }
          )
    end

    it "returns a CommandResult with success = false" do
      expect(subject.success).to be false
      expect(subject.message).to match /400/
      expect(subject.message).to match /Some error/
    end
  end

  context "when one of the pacticipants does not exist" do
    before do
      pact_broker
        .given("'Condor' does not exist in the pact-broker")
        .upon_receiving("a request to create a webhook for a consumer and provider")
        .with(
            method: :post,
            path: '/webhooks/provider/Pricing%20Service/consumer/Condor',
            headers: post_request_headers,
            body: request_body).
          will_respond_with(
            status: 404,
            headers: pact_broker_response_headers
          )
    end

    it "returns a CommandResult with success = false" do
      expect(subject.success).to be false
      expect(subject.message).to match /404/
    end
  end

  context "when only a consumer is specified" do
    before do
      params.delete(:provider)
      request_body["consumer"] = { "name" => "Condor" }
      mock_pact_broker_index(self)

      pact_broker
        .given("the 'Pricing Service' and 'Condor' already exist in the pact-broker")
        .upon_receiving("a request to create a webhook with a JSON body for a consumer")
        .with(
            method: :post,
            path: placeholder_path('pb:webhooks'),
            headers: post_request_headers,
            body: request_body)
        .will_respond_with(success_response)
    end

    it "returns a CommandResult with success = true" do
      expect(subject.success).to be true
      expect(subject.message).to eq "Webhook \"a webhook\" created"
    end
  end

  context "when only a consumer is specified and it does not exist" do
    before do
      params.delete(:provider)
      request_body["consumer"] = { "name" => "Condor" }
      mock_pact_broker_index(self)

      pact_broker
        .upon_receiving("a request to create a webhook with a JSON body for a consumer that does not exist")
        .with(
            method: :post,
            path: placeholder_path('pb:webhooks'),
            headers: post_request_headers,
            body: request_body)
        .will_respond_with(
            status: 400,
            headers: pact_broker_response_headers,
            body: {
              errors: {
                "consumer.name" => Pact.each_like("Some error")
              }
            })
    end

    it "returns a CommandResult with success = true" do
      expect(subject.success).to be false
    end
  end

  context "when only a provider is specified" do
    before do
      params.delete(:consumer)
      request_body["provider"] = { "name" => "Pricing Service" }
      mock_pact_broker_index(self)

      pact_broker
        .given("the 'Pricing Service' and 'Condor' already exist in the pact-broker")
        .upon_receiving("a request to create a webhook with a JSON body for a provider")
        .with(
            method: :post,
            path: placeholder_path('pb:webhooks'),
            headers: post_request_headers,
            body: request_body)
        .will_respond_with(success_response)
    end

    it "returns a CommandResult with success = true" do
      expect(subject.success).to be true
    end
  end

  context "when neither consumer nor provider are specified" do
    before do
      params.delete(:consumer)
      params.delete(:provider)
      mock_pact_broker_index(self)

      pact_broker
        .upon_receiving("a request to create a global webhook with a JSON body")
        .with(
            method: :post,
            path: placeholder_path('pb:webhooks'),
            headers: post_request_headers,
            body: request_body)
        .will_respond_with(success_response)
    end

    it "returns a CommandResult with success = true" do
      expect(subject.success).to be true
    end
  end

  context "when a uuid is specified" do
    before do
      params.merge!(uuid: uuid)
      request_body["provider"] = { "name" => "Pricing Service" }
      request_body["consumer"] = { "name" => "Condor" }
      mock_pact_broker_index_with_webhook_relation(self)
    end

    let(:uuid) { '696c5f93-1b7f-44bc-8d03-59440fcaa9a0' }

    context "when the webhook does not already exist" do
      before do
        pact_broker
          .upon_receiving("a request to create a webhook with a JSON body and a uuid")
          .given("the 'Pricing Service' and 'Condor' already exist in the pact-broker")
          .with(
              method: :put,
              path: "/webhooks/#{uuid}",
              headers: put_request_headers,
              body: request_body)
          .will_respond_with(success_response)
      end

      it "returns a CommandResult with success = true" do
        expect(subject).to be_a PactBroker::Client::CommandResult
        expect(subject.success).to be true
        expect(subject.message).to eq "Webhook \"a webhook\" created"
      end
    end

    context "when the webhook does exist" do
      before do
        pact_broker
          .upon_receiving("a request to update a webhook")
          .given("a webhook with the uuid #{uuid} exists")
          .with(
              method: :put,
              path: "/webhooks/#{uuid}",
              headers: put_request_headers,
              body: request_body)
          .will_respond_with(success_response)
      end

      let(:response_status) { 200 }

      it "returns a CommandResult with success = true" do
        expect(subject).to be_a PactBroker::Client::CommandResult
        expect(subject.success).to be true
        expect(subject.message).to eq "Webhook \"a webhook\" updated"
      end
    end
  end
end
