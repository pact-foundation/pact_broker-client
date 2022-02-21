require 'erb'
require 'delegate'
require 'pact_broker/client/error'
require 'pact_broker/client/hal/link'
require 'pact_broker/client/hal/links'

module PactBroker
  module Client
    module Hal
      class RelationNotFoundError < ::PactBroker::Client::Error; end
      class EmbeddedEntityNotFoundError < ::PactBroker::Client::Error; end
      class ErrorResponseReturned < ::PactBroker::Client::Error
        attr_reader :entity

        def initialize(message, entity)
          super(message)
          @entity = entity
        end
      end

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

        def get!(key, *args)
          get(key, *args).assert_success!
        end

        def post(key, *args)
          _link(key).post(*args)
        end

        def post!(key, *args)
          post(key, *args).assert_success!
        end

        def put(key, *args)
          _link(key).put(*args)
        end

        def put!(key, *args)
          put(key, *args).assert_success!
        end

        def patch(key, *args)
          _link(key).patch(*args)
        end

        def patch!(key, *args)
          patch(key, *args).assert_success!
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
          _link(key) or raise RelationNotFoundError.new(relation_not_found_error_message(key, @href))
        end

        def _links!(key)
          _links(key) or raise RelationNotFoundError.new(relation_not_found_error_message(key, @href))
        end

        def embedded_entity
          embedded_ent = yield @data["_embedded"]
          if embedded_ent
            Entity.new(self_href(embedded_ent), embedded_ent, @client, response)
          end
        end

        def embedded_entities!(key)
          embedded_ents = (@data["_embedded"] && @data["_embedded"][key])
          raise EmbeddedEntityNotFoundError.new("Could not find embedded entity with key '#{key}' in resource at #{@href}") unless embedded_ents
          embedded_ents.collect do | embedded_ent |
            Entity.new(self_href(embedded_ent), embedded_ent, @client, response)
          end
        end

        def embedded_entities(key = nil)
          embedded_ents = if key
            @data["_embedded"][key]
          else
            yield @data["_embedded"]
          end
          embedded_ents.collect do | embedded_ent |
            Entity.new(self_href(embedded_ent), embedded_ent, @client, response)
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
          if @data.respond_to?(:key?) && @data.key?(method_name.to_s)
            @data[method_name.to_s]
          elsif @links.respond_to?(:key?) && @links.key?(method_name)
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

        def self_href(entity_hash)
          entity_hash["_links"] && entity_hash["_links"]["self"] && entity_hash["_links"]["self"]["href"]
        end

        def relation_not_found_error_message(key, href)
          "Could not find relation '#{key}' in resource at #{href}. The most likely reason for this is that you are on an old version of the Pact Broker and you need to upgrade, or you are using Pactflow and you don't have the permissions required for this action."
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

        def error_message(messages = {})
          default_message = "Error making request to #{@href} status=#{response ? response.status: nil} #{response ? response.raw_body : ''}".strip
          message = if response && messages[response.status]
            (messages[response.status] || "") + " (#{default_message})"
          else
            default_message
          end
        end

        def assert_success!(messages = {})
          raise ErrorResponseReturned.new(error_message(messages), self)
        end
      end
    end
  end
end
