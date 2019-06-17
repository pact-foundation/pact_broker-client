require_relative 'pact_helper'

require 'pact_broker/client/certificates/add'

RSpec.describe "adding a certificate", pact: true do

  include_context "pact broker"
  include PactBrokerPactHelperMethods

  let(:description) { "The CI certificate" }
  let(:certificate_file_path) { "spec/support/cacert.pem" }
  let(:content) { File.read(certificate_file_path) }

  let(:certificate_params) do
    {
      content: content,
      description: description,
    }
  end

  let(:request_body) { certificate_params.to_json }

  let(:certificates_url) { pact_broker.mock_service_base_url + "/certificates" }

  let(:index_response) do
    {
      status: 200,
      headers: pact_broker_response_headers,
      body: {
        _links: {
          :'pb:certificates' => {
            href: Pact.term(certificates_url, /http/)
          }
        }
      }
    }
  end

  let(:success_response) do
    {
      status: 201,
      headers: pact_broker_response_headers,
      body: {
        _links: {
          self: {
            href: Pact.term('http://localhost:1234/certificate-url', /http/),
          }
        }
      }
    }
  end

  let(:pact_broker_client_options) { {} }
  let(:add_certificate_params) { { description: description, file_path: certificate_file_path } }

  subject { PactBroker::Client::Certificates::Add.call(add_certificate_params, broker_base_url, pact_broker_client_options) }

  before do
    pact_broker
      .given("the pb:add-certificate relation exists in the index resource")
      .upon_receiving("a request for the index resource")
      .with(
          method: :get,
          path: '/',
          headers: default_get_headers).
        will_respond_with(index_response)

  end

  context "when valid params are submitted" do
    before do
      pact_broker
        .upon_receiving("a request to add a certificate with valid params")
        .with(
            method: :post,
            path: '/certificates',
            headers: default_post_headers).
          will_respond_with(success_response)
    end

    it "returns a success result" do
      expect(subject.success).to be true
    end
  end

  context "when invalid params are submitted" do
    before do
      pact_broker
        .upon_receiving("a request to add a certificate with invalid params")
        .with(
            method: :post,
            path: '/certificates',
            headers: default_post_headers).
          will_respond_with(success_response)
    end

    let(:certificate_params){ {} }

    let(:error_response) do
      {
        status: 400,
        headers: pact_broker_response_headers,
        body: {
          errors: {
            content: "some error"
          }
        }
      }
    end

    it "returns an error result" do
      expect(subject.success).to be false
      expect(subject.message).to include "some error"
    end
  end
end
