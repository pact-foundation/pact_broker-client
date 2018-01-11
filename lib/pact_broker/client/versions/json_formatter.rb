require 'table_print'

module PactBroker
  module Client
    class Versions
      class JsonFormatter
        def self.call(matrix)
          JSON.pretty_generate(matrix)
        end
      end
    end
  end
end
