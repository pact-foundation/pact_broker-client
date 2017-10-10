require 'table_print'

module PactBroker
  module Client
    class Matrix
      class JsonFormatter
        def self.call(matrix_lines)
          JSON.pretty_generate(matrix: matrix_lines)
        end
      end
    end
  end
end
