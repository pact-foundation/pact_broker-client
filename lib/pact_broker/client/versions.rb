require 'pact_broker/client/base_client'
require 'pact_broker/client/versions/describe'
require 'pact_broker/client/versions/create'

# Old code
require 'pact_broker/client/pacts'

module PactBroker
  module Client
    class Versions < BaseClient

      def find options
        response = get("#{version_base_url(options)}", headers: default_get_headers)

        handle_response(response) do
          JSON.parse(response.body, symbolize_names: true)
        end
      end

      def latest options
        url = if options[:tag]
          url_for_relation('pb:latest-tagged-version', pacticipant: options.fetch(:pacticipant), tag: options.fetch(:tag))
        else
          url_for_relation('pb:latest-version', pacticipant: options.fetch(:pacticipant))
        end
        handle_response(get(url, headers: default_get_headers)) do | response |
          JSON.parse(response.body, symbolize_names: true)
        end
      end

      def tag options
        response = put(tag_url(options), headers: default_put_headers.merge("Content-Length" => "0"))
        handle_response(response) do
          true
        end
      end

      def update options
        body = options.select{ | key, v | [:repository_ref, :repository_url, :tags].include?(key)}
        body[:tags] ||= []
        (body[:tags] << options[:tag]) if options[:tag]
        response = patch("#{version_base_url(options)}", body: body, headers: default_patch_headers)
        handle_response(response) do
          true
        end
      end

      def pacts
        Pacts.new base_url: base_url, client_options: client_options
      end

      private

      def tag_url options
        "#{version_base_url(options)}/tags/#{encode_param(options.fetch(:tag))}"
      end

      def versions_base_url options
        pacticipant = encode_param(options.fetch(:pacticipant))
        "/pacticipants/#{pacticipant}/versions"
      end

      def version_base_url options
        version = encode_param(options.fetch(:version))
        "#{versions_base_url(options)}/#{version}"
      end
    end
  end
end