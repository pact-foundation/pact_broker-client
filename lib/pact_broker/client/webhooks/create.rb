require 'uri'
require 'pact_broker/client/hal'
require 'ostruct'
require 'json'
require 'pact_broker/client/command_result'

module PactBroker
  module Client
    module Webhooks
      class Create
        attr_reader  :params, :pact_broker_base_url, :basic_auth_options, :verbose

        def self.call(params, pact_broker_base_url, pact_broker_client_options)
          new(params, pact_broker_base_url, pact_broker_client_options).call
        end

        def initialize(params, pact_broker_base_url, pact_broker_client_options)
          @params = OpenStruct.new(params)
          @pact_broker_base_url = pact_broker_base_url
          @basic_auth_options = pact_broker_client_options[:basic_auth] || {}
          @verbose = pact_broker_client_options[:verbose]
        end

        def call
          request_body = JSON.parse(params.body) rescue params.body

          body = {
            events: params.events.collect{ | event | { "name" => event }},
            request: {
              url: params.url,
              method: params.http_method,
              headers: params.headers,
              body: request_body,
              username: params.username,
              password: params.password
            }
          }

          #TODO look for relation
          create_webhook_url = "#{pact_broker_base_url.chomp("/")}/webhooks/provider/{provider}/consumer/{consumer}"
          http_client = PactBroker::Client::Hal::HttpClient.new(basic_auth_options.merge(verbose: verbose))
          link = PactBroker::Client::Hal::Link.new({"href" => create_webhook_url}, http_client)
          entity = link.expand(consumer: params.consumer, provider: params.provider).post(body)
          if entity.success?
            CommandResult.new(true, "Webhook #{entity._link('self').title_or_name.inspect} created")
          else
            CommandResult.new(false, "Error creating webhook. response status=#{entity.response.code} body=#{entity.response.body}")
          end
        end
      end
    end
  end
end
