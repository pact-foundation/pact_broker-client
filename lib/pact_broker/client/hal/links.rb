require 'uri'
require 'delegate'

module PactBroker
  module Client
    module Hal
      class Links
        def initialize(href, key, links)
          @href = href
          @key = key
          @links = links
        end

        def find(name, not_found_message = nil)
          link = links.find{ | link | link.name == name }
          if link
            link
          else
            names = links.collect(&:name).compact.uniq
            message = not_found_message || "Could not find relation '#{key}' with name '#{name}' in resource at #{href}."
            available_options = names.any? ? names.join(", ") : "<none found>"
            raise RelationNotFoundError.new(message.chomp(".") + ". Available options: #{available_options}")
          end
        end

        private

        attr_reader :links, :key, :href
      end
    end
  end
end
