require 'pact_broker/client/matrix/json_formatter'
require 'pact_broker/client/matrix/text_formatter'

module PactBroker
  module Client
    class Matrix
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
