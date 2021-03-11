require 'erb'
require 'delegate'
require 'pact_broker/client/error'
require 'pact_broker/client/hal/link'
require 'pact_broker/client/hal/links'

module PactBroker
  module Client
    module Hal
      class RelationNotFoundError < ::PactBroker::Client::Error; end
      class ErrorResponseReturned < ::PactBroker::Client::Error; end

      class Entity
        def initialize(href, data, http_client, response = nil)
          @href = href
          @data = data
          @links = (@data || {}).fetch("_links", {})
          @client = http_client
          @response = response
        end

        def get(key, *args)
          _link(key).get(*args)
        end

        def post(key, *args)
          _link(key).post(*args)
        end

        def put(key, *args)
          _link(key).put(*args)
        end

        def patch(key, *args)
          _link(key).patch(*args)
        end

        def can?(key)
          @links.key? key.to_s
        end

        def follow(key, http_method, *args)
          Link.new(@links[key].merge(method: http_method), @client).run(*args)
        end

        def _link(key, fallback_key = nil)
          if @links[key]
            Link.new(@links[key], @client)
          elsif fallback_key && @links[fallback_key]
            Link.new(@links[fallback_key], @client)
          else
            nil
          end
        end

        def _links(key)
          if @links[key] && @links[key].is_a?(Array)
            link_collection = @links[key].collect do | hash |
              Link.new(hash, @client)
            end
            Links.new(@href, key, link_collection)
          elsif @links[key].is_a?(Hash)
            Links.new(@href, key, [Link.new(@links[key], @client)])
          else
            nil
          end
        end

        def _link!(key)
          _link(key) or raise RelationNotFoundError.new("Could not find relation '#{key}' in resource at #{@href}")
        end

        def _links!(key)
          _links(key) or raise RelationNotFoundError.new("Could not find relation '#{key}' in resource at #{@href}")
        end

        def embedded_entity
          embedded_ent = yield @data["_embedded"]
          Entity.new(embedded_ent["_links"]["self"]["href"], embedded_ent, @client, response)
        end

        def embedded_entities(key = nil)
          embedded_ents = if key
            @data["_embedded"][key]
          else
            yield @data["_embedded"]
          end
          embedded_ents.collect do | embedded_ent |
            Entity.new(embedded_ent["_links"]["self"]["href"], embedded_ent, @client, response)
          end
        end

        def success?
          true
        end

        def does_not_exist?
          false
        end

        def response
          @response
        end

        def fetch(key, fallback_key = nil)
          @links[key] || (fallback_key && @links[fallback_key])
        end

        def method_missing(method_name, *args, &block)
          if @data.key?(method_name.to_s)
            @data[method_name.to_s]
          elsif @links.key?(method_name)
            Link.new(@links[method_name], @client).run(*args)
          else
            nil
          end
        end

        def respond_to_missing?(method_name, include_private = false)
          @data.key?(method_name) || @links.key?(method_name)
        end

        def assert_success!(_ignored = nil)
          self
        end
      end

      class ErrorEntity < Entity
        def initialize(href, data, http_client, response = nil)
          @href = href
          @data = data
          @links = {}
          @client = http_client
          @response = response
        end

        def does_not_exist?
          response && response.status == 404
        end

        def success?
          false
        end

        def assert_success!(messages = {})
          default_message = "Error retrieving #{@href} status=#{response ? response.status: nil} #{response ? response.raw_body : ''}".strip
          message = if response && messages[response.status]
            (messages[response.status] || "") + " (#{default_message})"
          else
            default_message
          end
          raise ErrorResponseReturned.new(message)
        end
      end
    end
  end
end
