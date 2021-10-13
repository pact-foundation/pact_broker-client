require 'pact_broker/client/retry'
require 'pact_broker/client/hal/authorization_header_redactor'
require 'net/http'
require 'json'
require 'openssl'

module PactBroker
  module Client
    module Hal
      class HttpClient
        RETRYABLE_ERRORS = [Errno::ECONNREFUSED, Errno::ECONNRESET, Errno::ETIMEDOUT, Errno::EHOSTUNREACH, Net::ReadTimeout]
        attr_accessor :username, :password, :verbose, :token

        def initialize options
          @username = options[:username]
          @password = options[:password]
          @verbose = options[:verbose]
          @token = options[:token]
        end

        def get href, params = {}, headers = {}
          query = params.collect{ |(key, value)| "#{CGI::escape(key.to_s)}=#{CGI::escape(value.to_s)}" }.join("&")
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

        def delete href, body = nil, headers = {}
          uri = URI(href)
          perform_request(create_request(uri, 'Delete', body, headers), uri)
        end

        def create_request uri, http_method, body = nil, headers = {}
          request = Net::HTTP.const_get(http_method).new(uri.request_uri)
          request['Content-Type'] ||= "application/json" if ['Post', 'Put'].include?(http_method)
          request['Content-Type'] ||= "application/merge-patch+json" if ['Patch'].include?(http_method)
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
          response = until_truthy_or_max_times(condition: ->(resp) { resp.code.to_i < 500 }) do
            http = Net::HTTP.new(uri.host, uri.port, :ENV)
            http.set_debug_output(output_stream) if verbose?
            http.use_ssl = (uri.scheme == 'https')
            # Need to manually set the ca_file and ca_path for the pact-ruby-standalone.
            # The env vars seem to be picked up automatically in later Ruby versions.
            # See https://github.com/pact-foundation/pact-ruby-standalone/issues/57
            http.ca_file = ENV['SSL_CERT_FILE'] if ENV['SSL_CERT_FILE'] && ENV['SSL_CERT_FILE'] != ''
            http.ca_path = ENV['SSL_CERT_DIR'] if ENV['SSL_CERT_DIR'] && ENV['SSL_CERT_DIR'] != ''
            if disable_ssl_verification?
              if verbose?
                $stdout.puts("SSL verification is disabled")
              end
              http.verify_mode = OpenSSL::SSL::VERIFY_NONE
            end
            http.start do |http|
              http.request request
            end
          end
          Response.new(response)
        end

        def until_truthy_or_max_times options = {}
          max_tries = options.fetch(:times, default_max_tries)
          tries = 0
          sleep_interval = options.fetch(:sleep, 5)
          sleep(sleep_interval) if options[:sleep_first]
          while true
            begin
              result = yield
              return result if max_tries < 2
              if options[:condition]
                condition_result = options[:condition].call(result)
                return result if condition_result
              else
                return result if result
              end
              tries += 1
              return result if max_tries == tries
              sleep sleep_interval
            rescue *RETRYABLE_ERRORS => e
              tries += 1
              $stderr.puts "ERROR: Error making request - #{e.class} #{e.message} #{e.backtrace.find{|l| l.include?('pact_broker-client')}}, attempt #{tries} of #{max_tries}"
              raise e if max_tries == tries
              sleep sleep_interval
            end
          end
        end

        def default_max_tries
          5
        end

        def sleep seconds
          Kernel.sleep seconds
        end

        def output_stream
          AuthorizationHeaderRedactor.new($stdout)
        end

        def verbose?
          verbose || ENV["VERBOSE"] == "true"
        end

        def disable_ssl_verification?
          ENV['PACT_DISABLE_SSL_VERIFICATION'] == 'true' || ENV['PACT_BROKER_DISABLE_SSL_VERIFICATION'] == 'true'
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

          def headers
            __getobj__().to_hash
          end

          def header(name)
            __getobj__()[name]
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
