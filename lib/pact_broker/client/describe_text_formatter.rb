require 'yaml'
require 'pact_broker/client/generate_display_name'

module PactBroker
  module Client
    class DescribeTextFormatter
      extend GenerateDisplayName

      def self.call(properties)
        YAML.dump(displayify_keys(properties)).gsub("---\n", "")
      end

      def self.displayify_keys(thing)
        case thing
        when Hash then thing.each_with_object({}) { | (key, value), new_hash | new_hash[generate_display_name(key)] = displayify_keys(value) }
        when Array then thing.collect{ | value | displayify_keys(value) }
        else
          thing
        end
      end
    end
  end
end