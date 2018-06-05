require_relative 'base_client'
require 'pact_broker/client/pacts'
require 'pact_broker/client/hal/http_client'
require 'pact_broker/client/hal/link'

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
        puts options
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

      def add_environment options
        link_params = { pacticipant: options.fetch(:pacticipant), version: options.fetch(:version), environment: options.fetch(:environment) }
        http_client = PactBroker::Client::Hal::HttpClient.new(basic_auth_options || {})
        index_entity = PactBroker::Client::Hal::Link.new({'href' => base_url}, http_client).get
        if index_entity.success?
          environment_relation = index_entity._link("pb:pacticipant-version-environment")
          if environment_relation
            environment_entity = environment_relation.expand(link_params).put
            environment_entity.success?
          else
            raise PactBroker::Client::Error, "Support for environments does not exist in this version of the Pact Broker. Please upgrade to version 2.20.0 or later."
          end
        else
          raise PactBroker::Client::Error, "Error retrieving resource at #{base_url}: #{index_entity.info_message}"
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