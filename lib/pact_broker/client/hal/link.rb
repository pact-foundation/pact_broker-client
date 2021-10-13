require 'uri'
require 'delegate'

module PactBroker
  module Client
    module Hal
      class Link
        attr_reader :request_method, :href

        def initialize(attrs, http_client)
          @attrs = attrs
          @request_method = attrs.fetch(:method, :get).to_sym
          @href = attrs.fetch('href')
          @http_client = http_client
        end

        def run(payload = nil)
          response = case request_method
            when :get
              get(payload)
            when :put
              put(payload)
            when :post
              post(payload)
            end
        end

        def title_or_name
          title || name
        end

        def title
          @attrs['title']
        end

        def name
          @attrs['name']
        end

        def get(payload = {}, headers = {})
          wrap_response(href, @http_client.get(href, payload, headers))
        end

        def get!(*args)
          get(*args).assert_success!
        end

        def put(payload = nil, headers = {})
          wrap_response(href, @http_client.put(href, payload ? JSON.dump(payload) : nil, headers))
        end

        def put!(*args)
          put(*args).assert_success!
        end

        def post(payload = nil, headers = {})
          wrap_response(href, @http_client.post(href, payload ? JSON.dump(payload) : nil, headers))
        end

        def post!(*args)
          post(*args).assert_success!
        end

        def patch(payload = nil, headers = {})
          wrap_response(href, @http_client.patch(href, payload ? JSON.dump(payload) : nil, headers))
        end

        def patch!(*args)
          patch(*args).assert_success!
        end

        def delete(payload = nil, headers = {})
          wrap_response(href, @http_client.delete(href, payload ? JSON.dump(payload) : nil, headers))
        end

        def delete!(*args)
          delete(*args).assert_success!
        end

        def expand(params)
          expanded_url = expand_url(params, href)
          new_attrs = @attrs.merge('href' => expanded_url)
          Link.new(new_attrs, @http_client)
        end

        private

        def wrap_response(href, http_response)
          require "pact_broker/client/hal/entity" # avoid circular reference
          if http_response.success?
            Entity.new(href, http_response.body, @http_client, http_response)
          else
            body =  begin
                      http_response.header("Content-Type") && http_response.header("Content-Type").include?("json") ? http_response.body : http_response.raw_body
                    rescue
                      http_response.raw_body
                    end
            ErrorEntity.new(href, body, @http_client, http_response)
          end
        end

        def expand_url(params, url)
          params.inject(url) do | url, (key, value) |
            url.gsub('{' + key.to_s + '}', ERB::Util.url_encode(value))
          end
        end
      end
    end
  end
end
