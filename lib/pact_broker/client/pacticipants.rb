# New code
require 'pact_broker/client/pacticipants/create'
require 'pact_broker/client/pacticipants/describe'
require 'pact_broker/client/pacticipants/list'

# Old code
require 'pact_broker/client/base_client'

module PactBroker
  module Client
    class Pacticipants < BaseClient

      def versions
        Versions.new base_url: base_url, client_options: client_options
      end

      def update options
        body = options.select{ | key, v | [:repository_url].include?(key)}
        response = patch(pacticipant_base_url(options), body: body, headers: default_patch_headers)
        handle_response(response) do
          true
        end
      end

      def get1 options
        response = get(pacticipant_base_url(options), headers: default_get_headers)
        handle_response(response) do
          JSON.parse(response.body)
        end
      end

      def list
        response = get("/pacticipants", headers: default_get_headers)
        handle_response(response) do
          JSON.parse(response.body)
        end
      end

      def repository_url options
        response = get("#{pacticipant_base_url(options)}/repository_url", headers: default_get_headers.merge('Accept' => 'text/plain'))
        handle_response(response) do
          response.body
        end
      end

      private

      def pacticipant_base_url options
        "/pacticipants/#{encode_param(options[:pacticipant])}"
      end

    end
  end
end