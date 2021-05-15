# frozen_string_literal: true

require_relative 'base_client'
require 'pact_broker/client/matrix/resource'

module PactBroker
  module Client
    class Matrix < BaseClient
      def get selectors, options = {}
        latestby = selectors.size == 1 ? 'cvp' : 'cvpv'
        query = {
          q: convert_selector_hashes_to_params(selectors),
          latestby: latestby
        }.merge(query_options(options, selectors))
        response = self.class.get("/matrix", query: query, headers: default_get_headers)
        response = handle_response(response) do
          Matrix::Resource.new(JSON.parse(response.body, symbolize_names: true))
        end
      end

      def handle_response response
        if response.success?
          yield
        elsif response.code == 401
          message = "Authentication failed"
          if response.body && response.body.size > 0
            message = message + ": #{response.body}"
          end
          raise Error.new(message)
        elsif response.code == 404
          raise Error.new("Matrix resource not found at #{base_url}/matrix. Please upgrade your Broker to the latest version.")
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

      def query_options(options, selectors)
        opts = {}
        if options.key?(:success)
          opts[:success] = [*options[:success]]
        end
        opts[:limit] = options[:limit] if options[:limit]
        opts[:environment] = options[:to_environment] if options[:to_environment]
        if options[:to_tag]
          opts[:latest] = 'true'
          opts[:tag] = options[:to_tag]
        elsif selectors.size == 1 && !options[:to_environment]
          opts[:latest] = 'true'
        end
        if options[:ignore_selectors] && options[:ignore_selectors].any?
          opts[:ignore] = convert_selector_hashes_to_params(options[:ignore_selectors])
        end
        opts
      end

      def convert_selector_hashes_to_params(selectors)
        selectors.collect do |selector|
          { pacticipant: selector[:pacticipant] }.tap do | hash |
            hash[:version] = selector[:version] if selector[:version]
            hash[:latest] = 'true' if selector[:latest]
            hash[:tag] = selector[:tag] if selector[:tag]
            hash[:branch] = selector[:branch] if selector[:branch]
          end
        end
      end
    end
  end
end
