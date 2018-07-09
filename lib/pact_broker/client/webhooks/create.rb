require 'uri'
require 'pact_broker/client/hal'
require 'ostruct'
require 'json'
require 'pact_broker/client/command_result'

module PactBroker
  module Client
    module Webhooks
      class Create

        WEBHOOKS_WITH_OPTIONAL_PACTICICPANTS_NOT_SUPPORTED = "This version of the Pact Broker requires that both consumer and provider are specified for a webhook. Please upgrade your broker to >= 2.22.0 to create a webhook with optional consumer and provider."

        attr_reader  :params, :pact_broker_base_url, :basic_auth_options, :verbose

        def self.call(params, pact_broker_base_url, pact_broker_client_options)
          new(params, pact_broker_base_url, pact_broker_client_options).call
        end

        def initialize(params, pact_broker_base_url, pact_broker_client_options)
          @params = OpenStruct.new(params)
          @pact_broker_base_url = pact_broker_base_url
          @basic_auth_options = pact_broker_client_options[:basic_auth] || {}
          @verbose = pact_broker_client_options[:verbose]
          @http_client = PactBroker::Client::Hal::HttpClient.new(basic_auth_options.merge(verbose: verbose))
        end

        def call
          if params.consumer && params.provider
            create_webhook_with_consumer_and_provider
          else
            create_webhook_with_optional_consumer_and_provider
          end
        end

        private

        attr_reader :http_client

        def create_webhook_with_consumer_and_provider
          webhook_entity = webhook_link.expand(consumer: params.consumer, provider: params.provider).post(request_body)
          handle_response(webhook_entity)
        end

        def create_webhook_with_optional_consumer_and_provider
          webhook_entity = index_link.get._link("pb:webhooks").post(request_body_with_optional_consumer_and_provider)

          if webhook_entity.response.status == 405
            raise PactBroker::Client::Error.new(WEBHOOKS_WITH_OPTIONAL_PACTICICPANTS_NOT_SUPPORTED)
          end

          handle_response(webhook_entity)
        end

        def request_body
          webhook_request_body = JSON.parse(params.body) rescue params.body
          {
            events: params.events.collect{ | event | { "name" => event }},
            request: {
              url: params.url,
              method: params.http_method,
              headers: params.headers,
              body: webhook_request_body,
              username: params.username,
              password: params.password
            }
          }
        end

        def request_body_with_optional_consumer_and_provider
          body = request_body

          if params.consumer
            body[:consumer] = { name: params.consumer }
          end

          if params.provider
            body[:provider] = { name: params.provider }
          end

          body
        end

        def webhook_for_consumer_and_provider_url
          "#{pact_broker_base_url.chomp("/")}/webhooks/provider/{provider}/consumer/{consumer}"
        end

        def handle_response(webhook_entity)
          if webhook_entity.success?
            success_result(webhook_entity)
          else
            error_result(webhook_entity)
          end
        end

        def success_result(webhook_entity)
          CommandResult.new(true, "Webhook #{webhook_entity._link('self').title_or_name.inspect} created")
        end

        def error_result(webhook_entity)
          CommandResult.new(false, "Error creating webhook. response status=#{webhook_entity.response.status} body=#{webhook_entity.response.raw_body}")
        end

        def index_link
          PactBroker::Client::Hal::EntryPoint.new(pact_broker_base_url, http_client)
        end

        def webhook_link
          PactBroker::Client::Hal::EntryPoint.new(webhook_for_consumer_and_provider_url, http_client)
        end
      end
    end
  end
end
