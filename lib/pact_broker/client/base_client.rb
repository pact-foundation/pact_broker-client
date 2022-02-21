# frozen_string_literal: true

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
      ERROR_CODE_MAPPING = {
        401 => "Authentication failed",
        403 => "Authorization failed (insufficient permissions)",
        409 => "Potential duplicate pacticipants"
      }.freeze

      include UrlHelpers
      include HTTParty
      include StringToSymbol

      attr_reader :base_url, :client_options

      def initialize options
        @base_url = options[:base_url]
        @client_options = options[:client_options] || {}
        @verbose = @client_options[:verbose]
        self.class.base_uri base_url
        self.class.debug_output($stderr) if verbose?
        self.class.basic_auth(client_options[:basic_auth][:username], client_options[:basic_auth][:password]) if client_options[:basic_auth]
        self.class.headers('Authorization' => "Bearer #{client_options[:token]}") if client_options[:token]
        self.class.ssl_ca_file(ENV['SSL_CERT_FILE']) if ENV['SSL_CERT_FILE'] && ENV['SSL_CERT_FILE'] != ''
        self.class.ssl_ca_path(ENV['SSL_CERT_DIR']) if ENV['SSL_CERT_DIR'] && ENV['SSL_CERT_DIR'] != ''
        @default_options = {}
        @default_options[:verify] = false if (ENV['PACT_DISABLE_SSL_VERIFICATION'] == 'true' || ENV['PACT_BROKER_DISABLE_SSL_VERIFICATION'] == 'true')
      end

      def default_request_headers
        {'Accept' => 'application/hal+json, application/json'}
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
          yield response
        elsif response.code == 404
          nil
        elsif ERROR_CODE_MAPPING.key?(response.code)
          message = ERROR_CODE_MAPPING.fetch(response.code)
          if response.body && response.body.size > 0
            message = message + ": #{response.body}"
          end
          raise Error.new(message)
        else
          error_message = nil
          begin
            errors = JSON.parse(response.body)['errors']
            error_message = if errors.is_a?(Array)
              errors.join("\n")
            elsif errors.is_a?(Hash)
              errors.collect{ |key, value| "#{key}: #{value}" }.join("\n")
            else
              response.body
            end
          rescue
            raise Error.new("status=#{response.code} #{response.body}")
          end
          raise Error.new(error_message)
        end
      end

      def patch url, options
        self.class.patch(url, @default_options.merge(options.merge(body: options[:body].to_json)))
      end

      def put url, options = {}, &block
        self.class.put(url, @default_options.merge(options), &block)
      end

      def get url, options = {}, &block
        self.class.get(url, @default_options.merge(options), &block)
      end

      def url_for_relation relation_name, params
        handle_response(get("/", headers: default_get_headers)) do | response |
          relation = (JSON.parse(response.body)['_links'] || {})[relation_name]
          if relation
            url = relation['href']
            params.each do | (key, value) |
              url = url.gsub("{#{key}}", encode_param(value))
            end
            url
          else
            raise PactBroker::Client::RelationNotFound.new("Could not find relation #{relation_name} in index resource. Try upgrading your Pact Broker as the feature you require may not exist in your version. If you are using Pactflow, you may not have the permissions required for this action.")
          end
        end
      end

      def verbose?
        @verbose
      end
    end
  end
end
