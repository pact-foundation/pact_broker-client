
require 'pact/v2'
require 'pact/v2/rspec'
# require "combustion" # if ruby app is non rails, use combustion to load activesupport
require 'active_support/core_ext/object/deep_dup'
require 'active_support/core_ext/object/blank'
# https://guides.rubyonrails.org/active_support_core_extensions.html#stand-alone-active-support


def bar_provider
  has_http_pact_between 'Foo', 'Bar', opts: {
    pact_dir: "spec/pacts",
    log_level: :info,
    pact_specification: "2",
    # Valid versions are 1, 1.1, 2, 3, 4. Default is V4 
    # V prefix is optional, and case insensitive
  }

end

def pact_broker
  has_http_pact_between 'Pact Broker Client V2', 'Pact Broker', opts: {
    pact_dir: "spec/pacts",
    log_level: :info,
    mock_port: 9999,
    pact_specification: "2",
  }
end

def pactflow
  has_http_pact_between 'Pact Broker Client V2', 'PactFlow', opts: {
    pact_dir: "spec/pacts",
    log_level: :debug,
    mock_port: 9998,
    pact_specification: "2",
  }
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

  def placeholder_url(relation, params = [], mock_service_url = pact_broker)
    "#{mock_service_url}#{placeholder_path_for_term(relation, params)}"
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

  def placeholder_url_term(relation, params = [], mock_service_url = nil)
    regexp = "http:\/\/.*"
    if params.any?
      joined_params_for_regexp = params.collect{ |param| "{#{param}}"}.join(".*")
      regexp = "#{regexp}#{joined_params_for_regexp}"
    end

    match_regex(/#{regexp}/,placeholder_url(relation, params, mock_service_url))
  end

  def mock_pact_broker_index(context, mock_service_url = nil)
    new_interaction
      .upon_receiving("a request for the index resource")
      .with_request(
          method: :get,
          path: '/',
          headers: context.get_request_headers).
        will_respond_with(
          status: 200,
          headers: context.pact_broker_response_headers,
          body: {
            _links: {
              :'pb:webhooks' => {
                href: placeholder_url_term('pb:webhooks', [], mock_service_url)
              },
              :'pb:pacticipants' => {
                href: placeholder_url_term('pb:pacticipants', [], mock_service_url)
              },
              :'pb:pacticipant' => {
                href: placeholder_url_term('pb:pacticipant', ['pacticipant'], mock_service_url)
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

    new_interaction
      .given(provider_state)
      .upon_receiving("a request for the index resource")
      .with_request(
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

  def mock_pact_broker_index_with_webhook_relation(context, mock_service_url = nil)
    new_interaction
      .upon_receiving("a request for the index resource with the webhook relation")
      .with_request(
          method: :get,
          path: '/',
          headers: context.get_request_headers).
        will_respond_with(
          status: 200,
          headers: context.pact_broker_response_headers,
          body: {
            _links: {
              :'pb:webhook' => {
                href: match_regex(%r{http://.*/webhooks/{uuid}}, mock_service_url + "/webhooks/{uuid}"),
                templated: true
              }
            }
          }
        )
  end
end
