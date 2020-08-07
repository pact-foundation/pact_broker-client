require 'pact_broker/client/retry'
require 'pact_broker/client/hal/authorization_header_redactor'
require 'net/http'
require 'json'

module PactBroker
  module Client
    module Hal
      class HttpClient
        attr_accessor :username, :password, :verbose, :token

        def initialize options
          @username = options[:username]
          @password = options[:password]
          @verbose = options[:verbose]
          @token = options[:token]
        end

        def get href, params = {}, headers = {}
          query = params.collect{ |(key, value)| "#{CGI::escape(key)}=#{CGI::escape(value)}" }.join("&")
          uri = URI(href)
          uri.query = query
          perform_request(create_request(uri, 'Get', nil, headers), uri)
        end

        def put href, body = nil, headers = {}
          uri = URI(href)
          perform_request(create_request(uri, 'Put', body, headers), uri)
        end

        def post href, body = nil, headers = {}
          uri = URI(href)
          perform_request(create_request(uri, 'Post', body, headers), uri)
        end

        def patch href, body = nil, headers = {}
          uri = URI(href)
          perform_request(create_request(uri, 'Patch', body, headers), uri)
        end

        def create_request uri, http_method, body = nil, headers = {}
          request = Net::HTTP.const_get(http_method).new(uri.request_uri)
          request['Content-Type'] = "application/json" if ['Post', 'Put', 'Patch'].include?(http_method)
          request['Accept'] = "application/hal+json"
          headers.each do | key, value |
            request[key] = value
          end

          request.body = body if body
          request.basic_auth username, password if username
          request['Authorization'] = "Bearer #{token}" if token
          request
        end

        def perform_request request, uri
          response = Retry.until_truthy_or_max_times do
            http = Net::HTTP.new(uri.host, uri.port, :ENV)
            http.set_debug_output(output_stream) if verbose
            http.use_ssl = (uri.scheme == 'https')
            # Need to manually set the ca_file and ca_path for the pact-ruby-standalone.
            # The env vars seem to be picked up automatically in later Ruby versions.
            # See https://github.com/pact-foundation/pact-ruby-standalone/issues/57
            http.ca_file = ENV['SSL_CERT_FILE'] if ENV['SSL_CERT_FILE'] && ENV['SSL_CERT_FILE'] != ''
            http.ca_path = ENV['SSL_CERT_DIR'] if ENV['SSL_CERT_DIR'] && ENV['SSL_CERT_DIR'] != ''
            http.start do |http|
              http.request request
            end
          end
          Response.new(response)
        end

        def output_stream
          AuthorizationHeaderRedactor.new($stdout)
        end

        class Response < SimpleDelegator
          def body
            bod = raw_body
            if bod && bod != ''
              JSON.parse(bod)
            else
              nil
            end
          end

          def raw_body
            __getobj__().body
          end

          def status
            code.to_i
          end

          def success?
            __getobj__().code.start_with?("2")
          end
        end
      end
    end
  end
end
