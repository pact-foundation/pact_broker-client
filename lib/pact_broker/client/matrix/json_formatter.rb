require 'table_print'

module PactBroker
  module Client
    class Matrix
      class JsonFormatter
        def self.call(matrix)
          JSON.pretty_generate(matrix)
        end
      end
    end
  end
end
