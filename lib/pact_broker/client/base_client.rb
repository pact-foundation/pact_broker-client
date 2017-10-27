require 'erb'
require 'httparty'
require 'pact_broker/client/error'
require 'cgi'

module PactBroker
  module Client

    class Error < StandardError; end

    module UrlHelpers
      def encode_param param
        ERB::Util.url_encode param
      end

      def encode_query_param param
        CGI::escape param
      end
    end

    module StringToSymbol

      #Only works for one level, not recursive!
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

      attr_reader :base_url, :client_options

      def initialize options
        @base_url = options[:base_url]
        @client_options = options[:client_options] || {}
        @verbose = @client_options[:verbose]
        self.class.base_uri base_url
        self.class.basic_auth(client_options[:basic_auth][:username], client_options[:basic_auth][:password]) if client_options[:basic_auth]
      end

      def default_request_headers
        {'Accept' => 'application/json, application/hal+json'}
      end

      def default_get_headers
        default_request_headers
      end

      def default_patch_headers
        default_request_headers.merge('Content-Type' => 'application/json')
      end

      def default_put_headers
        default_request_headers.merge('Content-Type' => 'application/json')
      end

      def handle_response response
        if response.success?
          yield
        elsif response.code == 404
          nil
        elsif response.code == 401
          raise Error.new("Authentication failed")
        else
          error_message = nil
          begin
            error_message = JSON.parse(response.body)['errors'].join("\n")
          rescue
            raise Error.new(response.body)
          end
          raise Error.new(error_message)
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

      def verbose?
        @verbose
      end
    end
  end
end
