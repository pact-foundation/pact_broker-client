require_relative 'base_client'

module PactBroker
  module Client
    class Versions < BaseClient


      def latest options
        query = options[:tag] ? {tag: options[:tag]} : {}
        response = self.class.get("#{version_base_url(options)}/latest", query: query, headers: default_get_headers)

        handle_response(response) do
          string_keys_to_symbols(response.to_hash)
        end
      end

      def update options
        body = options.select{ | key, v | [:repository_ref, :repository_url, :tags].include?(key)}
        body[:tags] ||= []
        (body[:tags] << options[:tag]) if options[:tag]
        response = patch("#{version_base_url(options)}/#{options[:version]}", body: body, headers: default_patch_headers)
        handle_response(response) do
          true
        end
      end

      def pacts
        Pacts.new base_url: base_url
      end

      private
      def version_base_url options
        pacticipant = encode_param(options[:pacticipant])
        "/pacticipants/#{pacticipant}/versions"
      end
    end
  end
end