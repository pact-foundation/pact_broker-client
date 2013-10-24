require 'httparty'
require 'pact/consumer_contract'
require 'uri'
require 'erb'

module PactBroker

  class Client
    DEFAULT_OPTIONS = {base_url: 'http://pact-broker'}

    attr_reader :base_url

    def initialize options = {}
      merged_options = DEFAULT_OPTIONS.merge(options)
      @base_url = merged_options[:base_url]
    end

    def pacticipants
      PactBroker::ClientSupport::Pacticipants.new base_url: base_url
    end

  end

  module ClientSupport

    module UrlHelpers
      def encode_param param
        ERB::Util.url_encode param
      end
    end

    module StringToSymbol

      #Only works for one level, not recursive
      def string_keys_to_symbols hash
        hash.keys.each_with_object({}) do | key, new_hash |
          new_hash[key.to_sym] = hash[key]
        end
      end

    end


    class BaseClient
      include UrlHelpers
      include HTTParty
      include StringToSymbol

      attr_reader :base_url

      def initialize options
        @base_url = options[:base_url]
        self.class.base_uri base_url
      end

      def default_request_headers
        {'Accept' => 'application/json', 'X-Pact-Broker-Client-Version' => PactBroker::Client::VERSION}
      end

      def default_get_headers
        default_request_headers
      end

      def default_patch_headers
        default_request_headers.merge('Content-Type' => 'application/json+patch')
      end

      def default_put_headers
        default_request_headers.merge('Content-Type' => 'application/json')
      end

      def handle_response response
        if response.success?
          yield
        elsif response.code == 404
          nil
        else
          raise response.body
        end
      end

      def patch url, options
        self.class.patch(url, options.merge(body: options[:body].to_json))
      end

      def put url, *args
        self.class.put(url, *args)
      end

      def get url, *args
        self.class.get(url, *args)
      end

    end


    class Versions < BaseClient


      def last options
        query = options[:tag] ? {tag: options[:tag]} : {}
        response = self.class.get("#{version_base_url(options)}/last", query: query, headers: default_get_headers)

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
        "/#{pacticipant}/versions"
      end
    end

    class Pacticipants < BaseClient

      def versions
        Versions.new base_url: base_url
      end

      def update options
        body = options.select{ | key, v | [:repository_url].include?(key)}
        response = patch(pacticipant_base_url(options), body: body, headers: default_patch_headers)
        handle_response(response) do
          true
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
        "/#{encode_param(options[:pacticipant])}"
      end

    end

    class Pacts  < BaseClient

      def publish options
        consumer_version = options[:consumer_version]
        pact_string = options[:pact]
        consumer_contract = ::Pact::ConsumerContract.from_json pact_string
        url = save_consumer_contract_url consumer_contract, consumer_version
        response = self.class.put(url, body: pact_string, headers: default_put_headers)
        handle_response(response) do
          true
        end
      end

      def last options
        url = find_last_consumer_contract_url options
        query = options[:tag] ? {tag: options[:tag]} : {}
        response = self.class.get(url, headers: default_get_headers, query: query)
        handle_response(response) do
          response.body
        end
      end

      private

      def find_last_consumer_contract_url options
        consumer_name = encode_param(options[:consumer])
        provider_name = encode_param(options[:provider])
        "/#{consumer_name}/versions/last/pacts/#{provider_name}"
      end

      def save_consumer_contract_url consumer_contract, consumer_version
        consumer_name = encode_param(consumer_contract.consumer.name)
        provider_name = encode_param(consumer_contract.provider.name)
        version = encode_param(consumer_version)
        "/#{consumer_name}/versions/#{version}/pacts/#{provider_name}"
      end
    end
  end

end