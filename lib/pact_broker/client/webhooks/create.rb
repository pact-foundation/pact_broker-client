require 'uri'
require 'pact_broker/client/hal'
require 'ostruct'
require 'json'
require 'pact_broker/client/command_result'
require "pact_broker/client/backports"
require "pact_broker/client/hash_refinements"

module PactBroker
  module Client
    module Webhooks
      class Create
        using PactBroker::Client::HashRefinements

        WEBHOOKS_WITH_OPTIONAL_PACTICICPANTS_NOT_SUPPORTED = "This version of the Pact Broker requires that both consumer and provider are specified for a webhook. Please upgrade your broker to >= 2.22.0 to create a webhook with optional consumer and provider."
        CREATING_WEBHOOK_WITH_UUID_NOT_SUPPORTED = "This version of the Pact Broker does not support creating webhooks with a specified UUID. Please upgrade your broker to >= 2.49.0 or use the create-webhook command."

        attr_reader  :params, :pact_broker_base_url, :basic_auth_options, :verbose

        def self.call(params, pact_broker_base_url, pact_broker_client_options)
          new(params, pact_broker_base_url, pact_broker_client_options).call
        end

        def initialize(params, pact_broker_base_url, pact_broker_client_options)
          @params = OpenStruct.new(params)
          @pact_broker_base_url = pact_broker_base_url
          @http_client = PactBroker::Client::Hal::HttpClient.new(pact_broker_client_options.merge(pact_broker_client_options[:basic_auth] || {}))
        end

        def call
          if params.consumer && params.provider && !params.uuid
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
          index_entity = index_link.get!
          if params.uuid
            if index_entity.can?("pb:webhook")
              webhook_entity = index_entity._link("pb:webhook").expand(uuid: params.uuid).put(request_body_with_optional_consumer_and_provider)
            else
              return error_result(CREATING_WEBHOOK_WITH_UUID_NOT_SUPPORTED)
            end
          else
            webhook_entity = index_entity._link!("pb:webhooks").post(request_body_with_optional_consumer_and_provider)
          end

          if webhook_entity.response.status == 405
            return error_result(WEBHOOKS_WITH_OPTIONAL_PACTICICPANTS_NOT_SUPPORTED)
          end

          handle_response(webhook_entity)
        end

        def request_body
          webhook_request_body = JSON.parse(params.body) rescue params.body
          request_params = {
            url: params.url,
            method: params.http_method,
            headers: params.headers,
            body: webhook_request_body,
            username: params.username,
            password: params.password
          }.compact
          {
            events: params.events.collect{ | event | { "name" => event }},
            request: request_params
          }.tap { |req| req[:description] = params.description if params.description }
        end

        def request_body_with_optional_consumer_and_provider
          body = request_body

          if params.consumer
            body[:consumer] = { name: params.consumer }
          elsif params.consumer_label
            body[:consumer] = { label: params.consumer_label }
          end

          if params.provider
            body[:provider] = { name: params.provider }
          elsif params.provider_label
            body[:provider] = { label: params.provider_label }
          end

          if params.team_uuid
            body[:teamUuid] = params.team_uuid
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
            http_error_result(webhook_entity)
          end
        end

        def success_result(webhook_entity)
          action = webhook_entity.response.status == 201 ? "created" : "updated"
          name = if webhook_entity.description && webhook_entity.description.size > 0
            webhook_entity.description
          else
            webhook_entity._link('self').title_or_name
          end
          CommandResult.new(true, "Webhook #{name.inspect} #{action}")
        end

        def error_result(message)
          CommandResult.new(false, message)
        end

        def http_error_result(webhook_entity)
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
