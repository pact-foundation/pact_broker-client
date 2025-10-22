
require 'pact/v2'
require 'pact/v2/rspec'
# for pact/v2 with non rail apps
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
                href: generate_mock_server_url(
                  regex: ".*(\\/webhooks)$",
                  example: "/webhooks"
                )
              },
              :'pb:pacticipants' => {
                href: generate_mock_server_url(
                  regex: ".*(\\/pacticipants)$",
                  example: "/pacticipants"
                )
              },
              :'pb:pacticipant' => {
                href: generate_mock_server_url(
                  regex: ".*(\\/pacticipants\\/{pacticipant})$",
                  example: "/pacticipants/{pacticipant}"
                )
              }
            }
          }
        )
  end

end