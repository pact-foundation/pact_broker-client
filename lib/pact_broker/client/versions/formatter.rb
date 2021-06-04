# Need Versions class to extend BaseClient until we can remove the old Versions code
require 'pact_broker/client/base_client'
require 'pact_broker/client/versions/json_formatter'
require 'pact_broker/client/versions/text_formatter'

module PactBroker
  module Client
    class Versions < BaseClient
      class Formatter
        def self.call(matrix_lines, format)
          formatter = case format
          when 'json' then JsonFormatter
          when 'table' then TextFormatter
          else
            raise PactBroker::Client::Error.new("Invalid output option '#{format}. Must be one of 'table' or 'json'.")
          end
          formatter.call(matrix_lines)
        end
      end
    end
  end
end
