require 'spec_helper'
require 'pact/consumer/rspec'


Pact.configure do | config |
  config.logger.level = Logger::DEBUG
  config.doc_generator = :markdown
end

Pact.service_consumer 'Pact Broker Client' do
  has_pact_with "Pact Broker" do
    mock_service :pact_broker do
      port 1234
      pact_specification_version "2.0"
    end
  end

  has_pact_with "PactFlow" do
    mock_service :pactflow do
      port 1235
      pact_specification_version "2.0"
    end
  end
end

module PactBrokerPactHelperMethods

  # Use this for the path in the Pact request expectation.
  # @param [String] relation eg "pb:pacticipant"
  # @param [Array<String>] params eg ["Foo"]
  def placeholder_path(relation, params = [])
    path = "/HAL-REL-PLACEHOLDER-#{relation.gsub(':', '-').upcase}"
    if params.any?
      joined_params = params.join("-")
      path = "#{path}-#{joined_params}"
    end

    path
  end

  def placeholder_url(relation, params = [], mock_service = pact_broker)
    "#{mock_service.mock_service_base_url}#{placeholder_path_for_term(relation, params)}"
  end

  # @param [String] relation eg "pb:pacticipants"
  # @param [Array<String>] params eg ["pacticipant"]
  def placeholder_path_for_term(relation, params = [])
    path = "/HAL-REL-PLACEHOLDER-#{relation.gsub(':', '-').upcase}"
    if params.any?
      joined_params = params.collect{ |param| "{#{param}}"}.join("-")
      path = "#{path}-#{joined_params}"
    end

    path
  end

  def placeholder_url_term(relation, params = [], mock_service = pact_broker)
    regexp = "http:\/\/.*"
    if params.any?
      joined_params_for_regexp = params.collect{ |param| "{#{param}}"}.join(".*")
      regexp = "#{regexp}#{joined_params_for_regexp}"
    end

    Pact.term(placeholder_url(relation, params, mock_service), /#{regexp}/)
  end

  def mock_pact_broker_index(context, mock_service = pact_broker)
    mock_service
      .upon_receiving("a request for the index resource")
      .with(
          method: :get,
          path: '/',
          headers: context.get_request_headers).
        will_respond_with(
          status: 200,
          headers: context.pact_broker_response_headers,
          body: {
            _links: {
              :'pb:webhooks' => {
                href: placeholder_url_term('pb:webhooks', [], mock_service)
              },
              :'pb:pacticipants' => {
                href: placeholder_url_term('pb:pacticipants', [], mock_service)
              },
              :'pb:pacticipant' => {
                href: placeholder_url_term('pb:pacticipant', ['pacticipant'], mock_service)
              }
            }
          }
        )
  end

  def mock_pact_broker_index_with_relations(context, links, provider_state)
    _links = links.each_with_object({}) do | (key, value), new_links |
      new_links[key] = {
        href: value
      }
    end

    pact_broker
      .given(provider_state)
      .upon_receiving("a request for the index resource")
      .with(
          method: :get,
          path: '/',
          headers: context.get_request_headers).
        will_respond_with(
          status: 200,
          headers: context.pact_broker_response_headers,
          body: {
            _links: _links
          }
        )
  end

  def mock_pact_broker_index_with_webhook_relation(context)
    pact_broker
      .upon_receiving("a request for the index resource with the webhook relation")
      .with(
          method: :get,
          path: '/',
          headers: context.get_request_headers).
        will_respond_with(
          status: 200,
          headers: context.pact_broker_response_headers,
          body: {
            _links: {
              :'pb:webhook' => {
                href: Pact.term(pact_broker.mock_service_base_url + "/webhooks/{uuid}", %r{http://.*/webhooks/{uuid}}),
                templated: true
              }
            }
          }
        )
  end
end
